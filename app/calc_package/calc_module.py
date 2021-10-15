def addition(val1, val2):
    return val1 + val2


def subtraction(val1, val2):
    return val1 - val2


def multiplication(val1, val2):
    return val1 * val2


def division(val1, val2):
    if val1 != 0 and val2 != 0:
        return val1 / val2
    else:
        return "Division by zero exception"

def process(num1, num2, operation):
    if operation == '+':
        return addition(num1, num2)
    elif operation == '-':
        return subtraction(num1, num2)
    elif operation == '*':
        return multiplication(num1, num2)
    elif operation == '/':
        return division(num1, num2)
    else:
        return "Operation isn't supported"
