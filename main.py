from flask import Flask, jsonify
from functions import search_record_by_id

app = Flask(__name__)
app.config["JSON_SORT_KEYS"] = False


@app.route('/<indx>')
def show_record_by_id(indx):
    return jsonify(search_record_by_id(indx))


if __name__ == "__main__":
    app.run(debug=True)
