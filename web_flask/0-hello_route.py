#!/usr/bin/python3
#a script that starts a Flask web application:
#Your web application must be listening on 0.0.0.0, port 5000

from flask import Flask

app = Flask(__name__)

# Route for the home page
@app.route('/', strict_slashes=False)
def hello_hbnb():
    return 'Hello HBNB!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
