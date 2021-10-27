# Threatspec Project Threat Model

A threatspec project.


# Diagram
![Threat Model Diagram](ThreatModel.md.png)



# Exposures

## Stealing user information against CalcApp:Web:Server:DBMS
Incorrect permissions

```
# @exposes #db to #sui with incorrect permissions
def add_database(data):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS calculations (id INTEGER PRIMARY KEY, equation TEXT, result TEXT);")
            equation = str(data[0]) + " " + data[1] + " " + str(data[2])

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## Sql injection against CalcApp:Web:Server:DBMS
Not validating inputs

```
# @exposes #db to #sqli with not validating inputs
def add_database(data):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS calculations (id INTEGER PRIMARY KEY, equation TEXT, result TEXT);")
            equation = str(data[0]) + " " + data[1] + " " + str(data[2])

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## Sql injection against CalcApp:Web:Server:App
Not validating inputs

```
# @exposes #web_server to #sqli with not validating inputs




resource "aws_instance" "cyber94_mini_lcooper_app_tf" {

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## Cross-site scripting against CalcApp:Web:Server:App
Embedding input data into the html or javascript

```
# @exposes #web_server to #xss with embedding input data into the HTML or JavaScript



resource "aws_instance" "cyber94_mini_lcooper_app_tf" {
  ami = "ami-0943382e114f188e8"

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## Sql injection against CalcApp:Web:Server:App2
Not validating inputs

```
# @exposes #web_server2 to #sqli with not validating inputs


resource "aws_instance" "cyber94_mini_lcooper_app_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## Cross-site scripting against CalcApp:Web:Server:App2
Embedding input data into the html or javascript

```
# @exposes #web_server2 to #xss with embedding input data into the HTML or JavaScript

resource "aws_instance" "cyber94_mini_lcooper_app_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cyber94_mini_lcooper_sg_app_tf.id]

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1


# Acceptances


# Transfers


# Mitigations

## Sql injection against CalcApp:Web:Server:DBMS mitigated by Input validation


```
# @mitigates #db against #sqli with #iv
def add_database(data):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS calculations (id INTEGER PRIMARY KEY, equation TEXT, result TEXT);")
            equation = str(data[0]) + " " + data[1] + " " + str(data[2])

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## Sql injection against CalcApp:Web:Server:App mitigated by Input validation


```
# @mitigates #web_server against #sqli with #iv




resource "aws_instance" "cyber94_mini_lcooper_app_tf" {

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## Cross-site scripting against CalcApp:Web:Server:App mitigated by Input validation


```
# @mitigates #web_server against #xss with #iv



resource "aws_instance" "cyber94_mini_lcooper_app_tf" {
  ami = "ami-0943382e114f188e8"

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## Sql injection against CalcApp:Web:Server:App2 mitigated by Input validation


```
# @mitigates #web_server2 against #sqli with #iv


resource "aws_instance" "cyber94_mini_lcooper_app_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## Cross-site scripting against CalcApp:Web:Server:App2 mitigated by Input validation


```
# @mitigates #web_server2 against #xss with #iv

resource "aws_instance" "cyber94_mini_lcooper_app_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cyber94_mini_lcooper_sg_app_tf.id]

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1


# Reviews


# Connections

## CalcApp:Web:Server:App To CalcApp:Web:Server:DBMS
SQL Request

```
# @connects #web_server to #db with SQL Request
def add_database(data):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS calculations (id INTEGER PRIMARY KEY, equation TEXT, result TEXT);")
            equation = str(data[0]) + " " + data[1] + " " + str(data[2])

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## CalcApp:Web:Server:DBMS To CalcApp:Web:Server:App
SQL Response

```
# @connects #db to #web_server with SQL Response
def add_database(data):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS calculations (id INTEGER PRIMARY KEY, equation TEXT, result TEXT);")
            equation = str(data[0]) + " " + data[1] + " " + str(data[2])

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## CalcApp:Web:Server:App2 To CalcApp:Web:Server:DBMS
SQL Request

```
# @connects #web_server2 to #db with SQL Request
def add_database(data):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS calculations (id INTEGER PRIMARY KEY, equation TEXT, result TEXT);")
            equation = str(data[0]) + " " + data[1] + " " + str(data[2])

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## CalcApp:Web:Server:DBMS To CalcApp:Web:Server:App2
SQL Response

```
# @connects #db to #web_server2 with SQL Response
def add_database(data):
    with closing(sqlite3.connect("data.db")) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute("CREATE TABLE IF NOT EXISTS calculations (id INTEGER PRIMARY KEY, equation TEXT, result TEXT);")
            equation = str(data[0]) + " " + data[1] + " " + str(data[2])

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## External:SSH To CalcApp:Web:Server:Proxy
SSH

```
# @connects #ssh to #proxy with SSH

@flask_app.route('/')
def splash_page():
    print(request.headers)
    return render_template('splash_page.html')

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## External:SSH To CalcApp:Web:Server:App
SSH

```
# @connects #ssh to #web_server with SSH

@flask_app.route('/')
def splash_page():
    print(request.headers)
    return render_template('splash_page.html')

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## External:SSH To CalcApp:Web:Server:App2
SSH

```
# @connects #ssh to #web_server2 with SSH

@flask_app.route('/')
def splash_page():
    print(request.headers)
    return render_template('splash_page.html')

```
/home/kali/Documents/rest_api_calc_js/app/main.py:1

## CalcApp:VPC To CalcApp:VPC:Subnet
Network

```
# @connects #vpc to #subnet with Network
resource "aws_subnet" "cyber94_mini_lcooper_subnet_app_tf" {
    vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id
    cidr_block = "10.110.1.0/24"

    tags = {

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:VPC:Subnet:NACL To CalcApp:VPC:SG:App
Network

```
# @connects #nacl_app to #sg_app with Network

resource "aws_security_group" "cyber94_mini_lcooper_sg_app_tf" {
    name = "cyber94_mini_lcooper_sg_app"
    vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id


```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:VPC:Subnet:NACL To CalcApp:VPC:SG:Proxy
Network

```
# @connects #nacl_app to #sg_proxy with Network
resource "aws_security_group" "cyber94_mini_lcooper_sg_proxy_tf" {
    name = "cyber94_mini_lcooper_sg_proxy"
    vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id

    ingress {

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:VPC:Subnet To CalcApp:VPC:Subnet:NACL
Network

```
# @connects #subnet to #nacl_app with Network
resource "aws_network_acl" "cyber94_mini_lcooper_nacl_app_tf" {
  vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_mini_lcooper_subnet_app_tf.id]

  ingress {

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:VPC:SG:App To CalcApp:Web:Server:App
HTTPS/Get-Request

```
# @connects #sg_app to #web_server with HTTPS/Get-Request






```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:Web:Server:App To CalcApp:VPC:SG:App
HTTPS/Get-Response

```
# @connects #web_server to #sg_app with HTTPS/Get-Response






```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:VPC:SG:App To CalcApp:Web:Server:App2
HTTPS/Get-Request

```
# @connects #sg_app to #web_server2 with HTTPS/Get-Request






```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:Web:Server:App2 To CalcApp:VPC:SG:App
HTTPS/Get-Response

```
# @connects #web_server2 to #sg_app with HTTPS/Get-Response






```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:Web:Server:Proxy To CalcApp:VPC:SG:App
HTTPS/GET-Request

```
# @connects #proxy to #sg_app with HTTPS/GET-Request






```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:VPC:SG:App To CalcApp:Web:Server:Proxy
HTTPS/GET-Response

```
# @connects #sg_app to #proxy with HTTPS/GET-Response






```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## External:Guest To CalcApp:VPC:SG:Proxy
HTTPS/GET-Request

```
# @connects #guest to #sg_proxy with HTTPS/GET-Request

resource "aws_instance" "cyber94_mini_lcooper_proxy_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-lcooper"

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:VPC:SG:Proxy To External:Guest
HTTPS/GET-Response

```
# @connects #sg_proxy to #guest with HTTPS/GET-Response

resource "aws_instance" "cyber94_mini_lcooper_proxy_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-lcooper"

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:VPC:SG:Proxy To CalcApp:Web:Server:Proxy
HTTPS/GET-Request

```
# @connects #sg_proxy to #proxy with HTTPS/GET-Request

resource "aws_instance" "cyber94_mini_lcooper_proxy_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-lcooper"

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1

## CalcApp:Web:Server:Proxy To CalcApp:VPC:SG:Proxy
HTTPS/GET-Response

```
# @connects #proxy to #sg_proxy with HTTPS/GET-Response

resource "aws_instance" "cyber94_mini_lcooper_proxy_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-lcooper"

```
/home/kali/Documents/rest_api_calc_js/mini-infra/main.tf:1


# Components

## CalcApp:Web:Server:DBMS

## CalcApp:Web:Server:App

## CalcApp:Web:Server:App2

## External:SSH

## CalcApp:Web:Server:Proxy

## CalcApp:VPC

## CalcApp:VPC:Subnet

## CalcApp:VPC:Subnet:NACL

## CalcApp:VPC:SG:App

## CalcApp:VPC:SG:Proxy

## External:Guest


# Threats

## Sql injection


## Cross-site scripting


## Stealing user information



# Controls

## Input validation
