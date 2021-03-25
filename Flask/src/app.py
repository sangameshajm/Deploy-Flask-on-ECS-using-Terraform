from flask import Flask, request, abort, jsonify, redirect, url_for
from datetime import datetime

app = Flask(__name__)

# This method redirects users to /helloworld path.
@app.route('/')
def redirect_url():
    return  redirect(url_for('hello_world'))


# This method is for web requests where input is processed from the form and output is in rendered as HTML.
@app.route('/helloworld', methods=['POST', 'GET'])
def hello_world():
    timestamp = datetime.now().strftime("%m/%d/%Y %H:%M:%S")
    if request.method == 'POST':
        name = request.form.get('name')
        return '''<h1>Hello World {} !</h1><br>{}'''.format(name, timestamp)
    # otherwise handle the GET request
    return '''<form method="POST">
                   <div><label>Name: <input type="text" name="name"></label></div>
                   <input type="submit" value="Submit">
              </form>'''


# This method is for API requests where input and output is in JSON.
@app.route("/api/helloworld", methods=['POST', 'GET'])
def api_hello_world():
    if request.method == 'POST':
        request_data = request.get_json()

        if request_data:
            if 'name' in request_data:
                timestamp = datetime.now().strftime("%m/%d/%Y %H:%M:%S")
                try:
                    name = request_data['name']
                    if isinstance(name, str):
                        message = "Hello World {} !".format(name)
                    elif isinstance(name, list):
                        names = ""
                        for n in name:
                            names += " " + n
                        message = "Hello World{} !".format(names)
                    elif isinstance(name, dict):
                        names = ""
                        for n in name.keys():
                            names += " " + name[n]
                        message = "Hello World{} !".format(names)
                    else:
                        message = "Hello World {} !".format(name)
                    response = {'message': message, "timestamp": timestamp}
                    return jsonify(response)
                except (KeyError, TypeError):
                    abort(404)
            else:
                return jsonify({'error': 'JSON has no attribute name'}), 400
    elif request.method == 'GET':
        timestamp = datetime.now().strftime("%m/%d/%Y %H:%M:%S")
        message = "Hello World"
        response = {'message': message, "timestamp": timestamp}
        return jsonify(response)
    else:
        return abort(405)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
