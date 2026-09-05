from flask import Flask, render_template

app = Flask(__name__)


@app.route('/')
def hello():
    return render_template('index.html')  # This consumes the index.html file from the templates folder and renders it in the browser.


# This line is to specify that the application needs to be run in debug mode and on port 5500.
if __name__ == '__main__':
    app.run(debug=True, port=5500)
