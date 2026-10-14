#Q1

# Run in Terminal / Command Prompt

python --version
pip install flask pymongo

# Verify that Flask and PyMongo can be imported
python -c "import flask, pymongo; print('Flask', flask.__version__); print('PyMongo', pymongo.version)"

# Verify MongoDB shell / server
mongosh --version
mongosh

# (MongoDB Compass: open it and connect to  mongodb://localhost:27017 )

# Create the project
mkdir student_app
cd student_app
mkdir templates static

# test.py  (optional check file)
import flask
import pymongo
print("Flask and PyMongo imported successfully")
-------------------------------------------------------------------


#Q2
// Run in MongoDB Shell (mongosh)
use CollegeDB

db.createCollection("students")

db.students.insertMany([
  { student_id: 101, name: "Aman Sharma",  age: 21, gender: "Male",   department: "MCA",  marks: 82 },
  { student_id: 102, name: "Riya Verma",   age: 20, gender: "Female", department: "MCA",  marks: 74 },
  { student_id: 103, name: "Karan Singh",  age: 22, gender: "Male",   department: "BCA",  marks: 58 },
  { student_id: 104, name: "Neha Gupta",   age: 19, gender: "Female", department: "BCA",  marks: 91 },
  { student_id: 105, name: "Rohit Kumar",  age: 23, gender: "Male",   department: "BTech", marks: 66 },
  { student_id: 106, name: "Pooja Rawat",  age: 21, gender: "Female", department: "BTech", marks: 79 }
])

// Verify the documents
show dbs
show collections
db.students.find()
db.students.find().pretty()
db.students.countDocuments()
--------------------------------------------------------------------------------


#Q3
<!-- templates/add_student.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Registration</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="container">
        <h1>Student Registration Form</h1>
        <form action="/add" method="POST">

            <label for="student_id">Student ID</label>
            <input type="number" id="student_id" name="student_id" required>

            <label for="name">Student Name</label>
            <input type="text" id="name" name="name" required>

            <label for="age">Age</label>
            <input type="number" id="age" name="age" min="1" required>

            <label for="gender">Gender</label>
            <select id="gender" name="gender" required>
                <option value="">-- Select --</option>
                <option>Male</option>
                <option>Female</option>
                <option>Other</option>
            </select>

            <label for="department">Department</label>
            <input type="text" id="department" name="department" required>

            <label for="marks">Marks</label>
            <input type="number" id="marks" name="marks" min="0" max="100" required>

            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>

--------------------------------------------------------------------------------


#Q4
/* static/style.css */
* {
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background-color: #f0f2f5;
    margin: 0;
    padding: 0;
}

/* Navigation bar */
nav {
    background-color: #1f2a6b;
    padding: 12px 20px;
}

nav a {
    color: #ffffff;
    text-decoration: none;
    margin-right: 18px;
    font-weight: bold;
}

nav a:hover {
    text-decoration: underline;
}

/* Main layout */
.container {
    width: 90%;
    max-width: 600px;
    margin: 30px auto;
    background-color: #ffffff;
    padding: 25px 30px;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
}

.container.wide {
    max-width: 900px;
}

h1 {
    text-align: center;
    color: #1f2a6b;
    margin-top: 0;
}

/* Form */
label {
    display: block;
    margin-top: 14px;
    margin-bottom: 5px;
    font-weight: bold;
    color: #333333;
}

input, select {
    width: 100%;
    padding: 10px;
    border: 1px solid #bbbbbb;
    border-radius: 5px;
    font-size: 15px;
}

input:focus, select:focus {
    outline: none;
    border-color: #1f2a6b;
}

/* Buttons */
button, .btn {
    display: inline-block;
    margin-top: 20px;
    padding: 11px 22px;
    background-color: #1f2a6b;
    color: #ffffff;
    border: none;
    border-radius: 5px;
    font-size: 16px;
    cursor: pointer;
    text-decoration: none;
}

button:hover, .btn:hover {
    background-color: #3346b5;
}

.btn-danger {
    background-color: #c0392b;
}

.btn-danger:hover {
    background-color: #e74c3c;
}

/* Table */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

th, td {
    border: 1px solid #cccccc;
    padding: 10px;
    text-align: center;
}

th {
    background-color: #1f2a6b;
    color: #ffffff;
}

tr:nth-child(even) {
    background-color: #f5f6fa;
}

/* Messages */
.msg {
    padding: 10px;
    margin-bottom: 15px;
    border-radius: 5px;
    text-align: center;
}

.success { background-color: #d4edda; color: #155724; }
.error   { background-color: #f8d7da; color: #721c24; }
--------------------------------------------------------------------------------


#Q5
# app.py  - Connect Flask to CollegeDB.students

from flask import Flask
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient("mongodb://localhost:27017/")
db = client["CollegeDB"]
students = db["students"]

@app.route("/")
def home():
    try:
        client.admin.command("ping")
        count = students.count_documents({})
        return f"<h2>Successfully connected to MongoDB!</h2>" \
               f"<p>Database: CollegeDB | Collection: students | Documents: {count}</p>"
    except Exception as e:
        return f"<h2>Connection failed:</h2><p>{e}</p>"

if __name__ == "__main__":
    app.run(debug=True)
--------------------------------------------------------------------------------


#Q6
# app.py - add student route (HTML form -> Flask -> MongoDB)

from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient("mongodb://localhost:27017/")
students = client["CollegeDB"]["students"]

@app.route("/add", methods=["GET", "POST"])
def add_student():
    if request.method == "POST":
        student = {
            "student_id": int(request.form["student_id"]),
            "name": request.form["name"],
            "age": int(request.form["age"]),
            "gender": request.form["gender"],
            "department": request.form["department"],
            "marks": int(request.form["marks"])
        }
        students.insert_one(student)
        return redirect(url_for("view_students"))
    return render_template("add_student.html")

# (The form in Q3 already uses  action="/add"  method="POST")

// Verify in MongoDB shell after submitting the form:
use CollegeDB
db.students.find().sort({ _id: -1 }).limit(1)
db.students.find({ student_id: 107 })
--------------------------------------------------------------------------------


#Q7
# app.py - view all students

@app.route("/students")
def view_students():
    all_students = list(students.find({}, {"_id": 0}))
    return render_template("students.html", students=all_students)

<!-- templates/students.html -->
<!DOCTYPE html>
<html>
<head>
    <title>All Students</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="container wide">
        <h1>Student Records</h1>
        <table>
            <tr>
                <th>Student ID</th><th>Name</th><th>Age</th>
                <th>Gender</th><th>Department</th><th>Marks</th>
            </tr>
            {% for s in students %}
            <tr>
                <td>{{ s.student_id }}</td>
                <td>{{ s.name }}</td>
                <td>{{ s.age }}</td>
                <td>{{ s.gender }}</td>
                <td>{{ s.department }}</td>
                <td>{{ s.marks }}</td>
            </tr>
            {% else %}
            <tr><td colspan="6">No records found.</td></tr>
            {% endfor %}
        </table>
    </div>
</body>
</html>

// MongoDB shell equivalent:
db.students.find()
--------------------------------------------------------------------------------


#Q8
# app.py - search student by Student ID

@app.route("/search", methods=["GET", "POST"])
def search_student():
    student = None
    message = None
    if request.method == "POST":
        sid = int(request.form["student_id"])
        student = students.find_one({"student_id": sid}, {"_id": 0})
        if student is None:
            message = f"No student found with ID {sid}."
    return render_template("search.html", student=student, message=message)

<!-- templates/search.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Search Student</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="container">
        <h1>Search Student</h1>
        <form method="POST">
            <label>Enter Student ID</label>
            <input type="number" name="student_id" required>
            <button type="submit">Search</button>
        </form>

        {% if message %}
            <p class="msg error">{{ message }}</p>
        {% endif %}

        {% if student %}
        <table>
            <tr><th>Student ID</th><td>{{ student.student_id }}</td></tr>
            <tr><th>Name</th><td>{{ student.name }}</td></tr>
            <tr><th>Age</th><td>{{ student.age }}</td></tr>
            <tr><th>Gender</th><td>{{ student.gender }}</td></tr>
            <tr><th>Department</th><td>{{ student.department }}</td></tr>
            <tr><th>Marks</th><td>{{ student.marks }}</td></tr>
        </table>
        {% endif %}
    </div>
</body>
</html>

// MongoDB shell equivalent:
db.students.findOne({ student_id: 101 })
--------------------------------------------------------------------------------


#Q9
# app.py - update student (Name, Age, Department, Marks)

@app.route("/update", methods=["GET", "POST"])
def update_student():
    message = None
    updated = None
    if request.method == "POST":
        sid = int(request.form["student_id"])
        result = students.update_one(
            {"student_id": sid},
            {"$set": {
                "name": request.form["name"],
                "age": int(request.form["age"]),
                "department": request.form["department"],
                "marks": int(request.form["marks"])
            }}
        )
        if result.matched_count == 0:
            message = f"No student found with ID {sid}."
        else:
            message = f"Student {sid} updated successfully."
            updated = students.find_one({"student_id": sid}, {"_id": 0})
    return render_template("update.html", message=message, student=updated)

<!-- templates/update.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Update Student</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="container">
        <h1>Update Student</h1>
        <form method="POST">
            <label>Student ID (to update)</label>
            <input type="number" name="student_id" required>

            <label>New Name</label>
            <input type="text" name="name" required>

            <label>New Age</label>
            <input type="number" name="age" required>

            <label>New Department</label>
            <input type="text" name="department" required>

            <label>New Marks</label>
            <input type="number" name="marks" min="0" max="100" required>

            <button type="submit">Update</button>
        </form>

        {% if message %}<p class="msg success">{{ message }}</p>{% endif %}

        {% if student %}
        <table>
            <tr><th>ID</th><th>Name</th><th>Age</th><th>Dept</th><th>Marks</th></tr>
            <tr>
                <td>{{ student.student_id }}</td><td>{{ student.name }}</td>
                <td>{{ student.age }}</td><td>{{ student.department }}</td>
                <td>{{ student.marks }}</td>
            </tr>
        </table>
        {% endif %}
    </div>
</body>
</html>

// MongoDB shell equivalent + verification:
db.students.updateOne(
  { student_id: 101 },
  { $set: { name: "Aman S. Sharma", age: 22, department: "MCA", marks: 88 } }
)
db.students.find({ student_id: 101 })
--------------------------------------------------------------------------------


#Q10
# app.py - delete student by Student ID

@app.route("/delete", methods=["GET", "POST"])
def delete_student():
    message = None
    ok = False
    if request.method == "POST":
        sid = int(request.form["student_id"])
        result = students.delete_one({"student_id": sid})
        if result.deleted_count == 1:
            message = f"Student with ID {sid} deleted successfully."
            ok = True
        else:
            message = f"No student found with ID {sid}."
    return render_template("delete.html", message=message, ok=ok)

<!-- templates/delete.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Delete Student</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="container">
        <h1>Delete Student</h1>
        <form method="POST">
            <label>Enter Student ID</label>
            <input type="number" name="student_id" required>
            <button type="submit" class="btn-danger">Delete</button>
        </form>

        {% if message %}
            <p class="msg {{ 'success' if ok else 'error' }}">{{ message }}</p>
        {% endif %}
    </div>
</body>
</html>

// MongoDB shell equivalent:
db.students.deleteOne({ student_id: 106 })
db.students.find({ student_id: 106 })
--------------------------------------------------------------------------------


#Q11
// (a) Students belonging to a particular department
db.students.find({ department: "MCA" })

// (b) Students having marks greater than 75
db.students.find({ marks: { $gt: 75 } })

// (c) Students having marks between 50 and 80
db.students.find({ marks: { $gte: 50, $lte: 80 } })

// (d) Students older than 20
db.students.find({ age: { $gt: 20 } })

# app.py - the same queries through Flask

@app.route("/filter", methods=["GET", "POST"])
def filter_students():
    results = []
    title = ""
    if request.method == "POST":
        option = request.form["option"]
        if option == "a":
            dept = request.form["department"]
            results = list(students.find({"department": dept}, {"_id": 0}))
            title = f"Students in department: {dept}"
        elif option == "b":
            results = list(students.find({"marks": {"$gt": 75}}, {"_id": 0}))
            title = "Students with marks greater than 75"
        elif option == "c":
            results = list(students.find({"marks": {"$gte": 50, "$lte": 80}}, {"_id": 0}))
            title = "Students with marks between 50 and 80"
        elif option == "d":
            results = list(students.find({"age": {"$gt": 20}}, {"_id": 0}))
            title = "Students older than 20"
    return render_template("filter.html", students=results, title=title)

<!-- templates/filter.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Filter Students</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="container wide">
        <h1>Filter Students</h1>
        <form method="POST">
            <label>Choose Filter</label>
            <select name="option" required>
                <option value="a">(a) By Department</option>
                <option value="b">(b) Marks greater than 75</option>
                <option value="c">(c) Marks between 50 and 80</option>
                <option value="d">(d) Age greater than 20</option>
            </select>

            <label>Department (only for option a)</label>
            <input type="text" name="department" placeholder="e.g. MCA">

            <button type="submit">Show Results</button>
        </form>

        {% if title %}<h3>{{ title }}</h3>{% endif %}
        {% if students %}
        <table>
            <tr><th>ID</th><th>Name</th><th>Age</th><th>Gender</th><th>Department</th><th>Marks</th></tr>
            {% for s in students %}
            <tr>
                <td>{{ s.student_id }}</td><td>{{ s.name }}</td><td>{{ s.age }}</td>
                <td>{{ s.gender }}</td><td>{{ s.department }}</td><td>{{ s.marks }}</td>
            </tr>
            {% endfor %}
        </table>
        {% elif title %}
            <p class="msg error">No matching records.</p>
        {% endif %}
    </div>
</body>
</html>
--------------------------------------------------------------------------------


#Q12
# ===================== app.py  (COMPLETE APPLICATION) =====================
from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient("mongodb://localhost:27017/")
db = client["CollegeDB"]
students = db["students"]


# ---------- HOME ----------
@app.route("/")
def home():
    try:
        client.admin.command("ping")
        status = "Connected to MongoDB (CollegeDB.students)"
    except Exception:
        status = "MongoDB connection failed"
    return render_template("home.html", status=status, total=students.count_documents({}))


# ---------- ADD ----------
@app.route("/add", methods=["GET", "POST"])
def add_student():
    message = None
    if request.method == "POST":
        sid = int(request.form["student_id"])
        if students.find_one({"student_id": sid}):
            message = ("error", f"Student ID {sid} already exists.")
        else:
            students.insert_one({
                "student_id": sid,
                "name": request.form["name"],
                "age": int(request.form["age"]),
                "gender": request.form["gender"],
                "department": request.form["department"],
                "marks": int(request.form["marks"])
            })
            message = ("success", "Student added successfully.")
    return render_template("add_student.html", message=message)


# ---------- VIEW ----------
@app.route("/students")
def view_students():
    return render_template("students.html", students=list(students.find({}, {"_id": 0})))


# ---------- SEARCH ----------
@app.route("/search", methods=["GET", "POST"])
def search_student():
    student, message = None, None
    if request.method == "POST":
        sid = int(request.form["student_id"])
        student = students.find_one({"student_id": sid}, {"_id": 0})
        if student is None:
            message = f"No student found with ID {sid}."
    return render_template("search.html", student=student, message=message)


# ---------- UPDATE ----------
@app.route("/update", methods=["GET", "POST"])
def update_student():
    message, updated = None, None
    if request.method == "POST":
        sid = int(request.form["student_id"])
        result = students.update_one(
            {"student_id": sid},
            {"$set": {
                "name": request.form["name"],
                "age": int(request.form["age"]),
                "department": request.form["department"],
                "marks": int(request.form["marks"])
            }}
        )
        if result.matched_count == 0:
            message = f"No student found with ID {sid}."
        else:
            message = f"Student {sid} updated successfully."
            updated = students.find_one({"student_id": sid}, {"_id": 0})
    return render_template("update.html", message=message, student=updated)


# ---------- DELETE ----------
@app.route("/delete", methods=["GET", "POST"])
def delete_student():
    message, ok = None, False
    if request.method == "POST":
        sid = int(request.form["student_id"])
        result = students.delete_one({"student_id": sid})
        if result.deleted_count == 1:
            message, ok = f"Student with ID {sid} deleted successfully.", True
        else:
            message = f"No student found with ID {sid}."
    return render_template("delete.html", message=message, ok=ok)


# ---------- FILTER ----------
@app.route("/filter", methods=["GET", "POST"])
def filter_students():
    results, title = [], ""
    if request.method == "POST":
        option = request.form["option"]
        if option == "a":
            dept = request.form["department"]
            results = list(students.find({"department": dept}, {"_id": 0}))
            title = f"Students in department: {dept}"
        elif option == "b":
            results = list(students.find({"marks": {"$gt": 75}}, {"_id": 0}))
            title = "Students with marks greater than 75"
        elif option == "c":
            results = list(students.find({"marks": {"$gte": 50, "$lte": 80}}, {"_id": 0}))
            title = "Students with marks between 50 and 80"
        elif option == "d":
            results = list(students.find({"age": {"$gt": 20}}, {"_id": 0}))
            title = "Students older than 20"
    return render_template("filter.html", students=results, title=title)


if __name__ == "__main__":
    app.run(debug=True)


<!-- =================== templates/base.html (navigation) =================== -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{% block title %}Student Record Management{% endblock %}</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <nav>
        <a href="/">Home</a>
        <a href="/add">Add Student</a>
        <a href="/students">View Students</a>
        <a href="/search">Search Student</a>
        <a href="/update">Update Student</a>
        <a href="/delete">Delete Student</a>
        <a href="/filter">Filter</a>
    </nav>
    {% block content %}{% endblock %}
</body>
</html>


<!-- =================== templates/home.html =================== -->
{% extends "base.html" %}
{% block content %}
<div class="container">
    <h1>Student Record Management System</h1>
    <p class="msg success">{{ status }}</p>
    <p style="text-align:center;">Total students: <b>{{ total }}</b></p>
    <p style="text-align:center;">HTML &rarr; Flask &rarr; PyMongo &rarr; MongoDB &rarr; Document</p>
</div>
{% endblock %}


<!-- =================== templates/add_student.html (final) =================== -->
{% extends "base.html" %}
{% block content %}
<div class="container">
    <h1>Add Student</h1>
    {% if message %}<p class="msg {{ message[0] }}">{{ message[1] }}</p>{% endif %}
    <form action="/add" method="POST">
        <label>Student ID</label>
        <input type="number" name="student_id" required>
        <label>Student Name</label>
        <input type="text" name="name" required>
        <label>Age</label>
        <input type="number" name="age" min="1" required>
        <label>Gender</label>
        <select name="gender" required>
            <option value="">-- Select --</option>
            <option>Male</option><option>Female</option><option>Other</option>
        </select>
        <label>Department</label>
        <input type="text" name="department" required>
        <label>Marks</label>
        <input type="number" name="marks" min="0" max="100" required>
        <button type="submit">Submit</button>
    </form>
</div>
{% endblock %}


<!-- students.html, search.html, update.html, delete.html and filter.html are the
     same as in Q7, Q8, Q9, Q10 and Q11: wrap their body content inside
     {% extends "base.html" %} {% block content %} ... {% endblock %} -->

# Run the complete application:
#   cd student_app
#   python app.py
#   Open http://127.0.0.1:5000/
