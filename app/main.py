from flask import Flask, make_response, request, render_template, redirect, jsonify
import jwt
import datetime
import sqlite3
from contextlib import closing
import hashlib
from calc_package import calc_module
from decouple import config

# Create your own file called .env and enter KEY=[256-bit hex key]
SECRET_KEY = config('KEY')
flask_app = Flask(__name__)


# @component CalcApp:Web:Server:DBMS (#db)
# @connects #login to #db with SQL Request
# @connects #db to #login with SQL Response
# @connects #auth to #db with SQL Request
# @connects #db to #auth with SQL Response
# @threat Stealing User Information (#sui)
# @exposes #db to #sui with incorrect permissions
# @exposes #db to #sqli with not validating inputs
# @mitigates #db against #sqli with #iv
def add_database(data):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS calculations (id INTEGER PRIMARY KEY, equation TEXT, result TEXT);")
            equation = str(data[0]) + " " + data[1] + " " + str(data[2])
            result = data[3]
            cursor.execute("INSERT INTO calculations (equation, result) VALUES (?, ?);", (str(equation), result,))
            connection.commit()


def create_token(username):
    validity = datetime.datetime.utcnow() + datetime.timedelta(days=2)
    token = jwt.encode({'username': username, 'expiry': str(validity)}, SECRET_KEY, "HS256")
    return token


def verify_token(token):
    if token:
        decoded_token = jwt.decode(token, SECRET_KEY, "HS256")
        print(decoded_token)
        with closing(sqlite3.connect("data.db")) as conn:
            with closing(conn.cursor()) as cursor:
                cursor.execute("SELECT * FROM users WHERE username = ? AND token = ?;",
                               (decoded_token['username'], token,))
                data = cursor.fetchall()
                if len(data) == 0:
                    return False
                else:
                    return True

@flask_app.after_request
def apply_caching(response):
    response.headers["X-Frame-Options"] = "SAMEORIGIN"
    response.headers['X-Content-Type-Options'] = "nosniff"
    return response


# @component CalcApp:Web:Server:Calc Page (#calcpage)
# @connects #calcpage to #db with SQL Request
# @connects #db to #calcpage with SQL Response
@flask_app.route('/calc')
def calc_page():
    global new_user
    isUserLoggedIn = False
    if 'token' in request.cookies:
        isUserLoggedIn = verify_token(request.cookies['token'])
    if isUserLoggedIn:
        decoded_token = jwt.decode(request.cookies['token'], SECRET_KEY, "HS256")
        username = decoded_token['username']
        if new_user == False:
            return render_template('calc.html', value=f"Welcome {username}!")
        elif new_user == True:
            new_user = False
            return render_template('new_account.html')
    else:
        return redirect("/")


# @component CalcApp:Web:Server:PyCalc (#pycalc)
# @connects #proxy to #pycalc with HTTPS/POST-Request
# @connects #pycalc to #proxy with HTTPS/POST-Response
@flask_app.route('/calculate', methods=['POST'])
def calculator():
    if request.form['number1'].isdigit() and request.form['number2'].isdigit():
        num1 = int(request.form['number1'])
        num2 = int(request.form['number2'])
        operation = request.form['operation']
    else:
        return render_template("calc.html", value="Only enter digits please.")
    answer = calc_module.process(num1, num2, operation)
    return render_template('calc.html', answer=f"{answer}")
    """add = calc_module.addition(num1, num2)
    add_database((num1, "+", num2, add))
    sub = calc_module.subtraction(num1, num2)
    add_database((num1, "-", num2, sub))
    mul = calc_module.multiplication(num1, num2)
    add_database((num1, "*", num2, mul))
    div = calc_module.division(num1, num2)
    add_database((num1, "/", num2, div))
    return render_template('calc.html', addi=f"Addition: {add}", subt=f"Subtraction: {sub}",
                           mult=f"Multiplication: {mul}", divi=f"Division: {div}")"""


# @component External:User (#user)
# @connects #user to #proxy with HTTPS/GET-Request
# @connects #proxy to #user with HTTPS/GET-Response

# @component External:Guest (#guest)
# @connects #guest to #proxy with HTTPS/GET-Request
# @connects #proxy to #guest with HTTPS/GET-Reponse

# @component External:Developer SSH (#ssh)
# @connects #ssh to #proxy with SSH
# @connects #ssh to #web_server with SSH
# @connects #ssh to #web_server2 with SSH

# @component CalcApp:Web:Server:Splash Page (#splash)
# @connects #proxy to #splash with HTTPS/GET-Request
# @connects #splash to #proxy with HTTPS/GET-Response
@flask_app.route('/')
def splash_page():
    print(request.headers)
    return render_template('splash_page.html')


# @component CalcApp:Web:Server:Login (#login)
# @connects #proxy to #login with HTTPS/GET-Request
# @connects #login to #proxy with HTTPS/GET-Response
@flask_app.route('/login')
def login_page():
    global new_user
    isUserLoggedIn = False
    if 'token' in request.cookies:
        isUserLoggedIn = verify_token(request.cookies['token'])
    if isUserLoggedIn:
        new_user = False
        return redirect('/calc')
    else:
        return render_template('login.html')


# @component CalcApp:Web:Server:Authenticate (#auth)
# @connects #proxy to #auth with HTTPS/POST-Request
# @connects #auth to #proxy with HTTPS/POST-Response
@flask_app.route('/authenticate', methods=['POST'])
def authenticate_users():
    global new_user
    data = request.form
    username = data['username']
    password = data['password']
    password = hashlib.sha256(password.encode()).hexdigest()
    with closing(sqlite3.connect("data.db")) as conn:
        with closing(conn.cursor()) as cursor:
            cursor.execute(
                "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, token TEXT);")
            conn.commit()
            cursor.execute("SELECT * FROM users WHERE username = ? AND password = ?;", (username, password,))
            rows = cursor.fetchall()
            if len(rows) == 0:
                new_user = True
                cursor.execute("INSERT INTO users (username, password) VALUES (?, ?);", (username, password))
                conn.commit()
                user_token = create_token(username)
                cursor.execute("UPDATE users SET token = ? WHERE username = ? AND password = ?;",
                               (user_token, username, password,))
                conn.commit()
                resp = make_response(redirect('/calc'))
                resp.set_cookie('token', user_token, max_age=60*60*24*2, httponly=True, secure=True, samesite='Strict')
                return resp
            else:
                new_user = False
                user_token = create_token(username)
                cursor.execute("UPDATE users SET token = ? WHERE username = ? AND password = ?;",
                               (user_token, username, password,))
                conn.commit()
                resp = make_response(redirect('/calc'))
                resp.set_cookie('token', user_token, max_age=60*60*24*2, httponly=True, secure=True, samesite='Strict')
                return resp


# @component CalcApp:Web:Server:Logout (#logout)
# @connects #proxy to #logout with HTTPS/GET-Request
# @connects #logout to #proxy with HTTPS/GET-Response
@flask_app.route('/logout')
def logout():
    if 'token' in request.cookies:
        value = request.cookies.get('token')
        resp = make_response(redirect('/'))
        resp.set_cookie('token', value, max_age=0, secure=True)
        return resp
    else:
        return redirect('/')


# @component CalcApp:Web:Server:JsCalc (#jscalc)
# @connects #proxy to #jscalc with HTTPS/GET-Request
# @connects #jscalc to #proxy with HTTPS/GET-Response
@flask_app.route('/calculate2', methods=['POST'])
def calculate2_post():
    if request.form['number1'].isdigit() and request.form['number2'].isdigit():
        num1 = request.form.get('number1', type=int)
        num2 = request.form.get('number2', type=int)
        operation = request.form.get('operation', type=str)
    else:
        return render_template("calc.html", value="Only enter digits please.")
    answer = calc_module.process(num1, num2, operation)
    response_data = {
        'data': answer
    }
    return make_response(jsonify(response_data))


if __name__ == '__main__':
    print("This is a REST API Calculator")
    flask_app.run(ssl_context=('certs/cert.pem', 'certs/key.pem'), host='0.0.0.0')
