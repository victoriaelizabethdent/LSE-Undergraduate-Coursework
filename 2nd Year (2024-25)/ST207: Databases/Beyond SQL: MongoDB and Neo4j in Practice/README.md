[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/damPLJ3p)
# Assignment 2 (AT2024)

## Overall objective

This assignment is intended to assess your knowledge of NoSQL database programming.

## Instructions (read carefully)

* The assignment comprises **two questions**, each worth 50% of the mark.
* You **must** write **one Python code (notebook) for each question**. Please, **DO NOT** submit one single file as your solutions will be assessed by different markers.
* Make sure **your code files show the results for each cell**, especially those commands retrieving data from the database. You can export a PDF or HTML of your notebook and upload it along with your Python notebook.
* Remember that this is a **2-step submission process**: once you have all your files on GitHub, copy the link to your GitHub repository and submit it through Moodle ([Coursework submissions](https://moodle.lse.ac.uk/course/view.php?id=11282) section). Avoid, as much as possible, any identifiable information (other than your candidate number) on your submitted work.

<hr>

### Question 1: MongoDB

In this question, you will use the **Northwind** example database as a **collection of documents** to answer some questions.

1. Set up a MongoDB Atlas cluster.
2. Create a Python notebook with `PyMongo` installed, and connect it to your Atlas cluster.
3. Download the Northwind database (CSV files) from the [data](./data) folder. There are 6 files mapping categories, customers, employees, orders, products, and suppliers.
4. Have a look at the **Northwind Entity-Relationship model** ([fig](./fig) folder) to get a sense of existing entities, primary/foreign keys, and relationships. Notice that `Orders` and `Order_Details` were merged into one single file (`orders.csv`).
5. Answer the questions below (write Python code for that). See a reference [SQL code](./code) for questions 1B-1D.

1A) Create a new database (`db`) called `Northwind` and load each CSV file into a new collection (for instance, `customers.csv` into `db["customers"]`. **Important:** when loading the CSV data into a collection, check for relationships (foreign keys) between two entities (for instance, `products` and `suppliers`). **You should create all relationships manually**, by figuring out how to make one document (from one collection) refer to a document in another collection. **Tip:** use the object IDs.

1B) List all product names and unit prices supplied by each company (supplier), along with the supplier's name.

1C) List the categories of the 10 top-seller products.

1D) For each customer, list all products they bought.

<hr>

### Question 2: Neo4j

In this question, you will **transpose an E-R model into a graph database**.

1. Set up a Neo4j AuraDB cluster.
2. Create a Python notebook with a Neo4 driver installed, and connect it to your AuraDB cluster.
3. Refer to **the E-R model you developed for Assignment 1** and identify all entities, attributes, and relationships. Then, **design a Property Graph model** mapping these elements into nodes, labels, properties, and relationships.
4. Answer the questions below (write Python code for that):

2A) Create your graph database, based on your Property Graph model translated from your E-R model. Feel free to adapt your E-R model as needed. Draw your Property Graph Model (you can use [Arrows.app](https://arrows.app) or any other application for that).
[This ebook](https://neo4j.com/whitepapers/definitive-guide-graph-databases-rdbms-developer/) is a good reference.

2B) Populate your graph with the data you used in Assignment 1. This can be i) hardcoded (manually creating all nodes, labels, properties, and relationships) OR ii) loaded from CSV files used in/exported from your first assignment. Show the final (instance) graph: i) on your Python code, using *yFiles* (see Seminar 9), or ii) a screenshot taken from your AuraDB instance and uploaded along with your code.

Answer the following queries:

2C) You were asked to produce a list of all customers and their orders, including the list
of products in each order and the (grand) total paid. Your query must show the
customer’s name and email, order number, order date, the list of products in each order
and the total of each order.

2D) You were asked to list all customers who have items in their baskets, so the
company can make special oEers based on their birthdays and any balance on existing
gift cards. You must retrieve the customer identification (e-mail), name, birthday, any
balance from gift cards, and the list of products in their baskets.

2E) You were asked to identify the top two items sold in each product category, so the
company can ensure that these products are kept in stock and marketed prominently.
You must retrieve the category names, the top two products from each category, and
their total sales.

<hr>

## Key dates

* Assignment released: 29/11/2024, 5:00 pm.
* Solution deadline: 13/12/2024, 5:00 pm (**both GitHub and Moodle**)
* Feedback and provisional marks (tentative): 17/01/2025, 5:00 pm.
* See Moodle for late submission penalties.

<hr>

## Generative AI tools

As per School and course-specific policy, you may acknowledge the use of any generative AI tool in any part of your summative work. You may note that marks can be deducted if no acknowledgement is made and/or a substantial part of your work (especially coding) is done by these tools. See [Moodle](https://moodle.lse.ac.uk/course/view.php?id=11282) for guidance.

You may use these tools literally as a “co-pilot” to help you prototype your database models, generate synthetic data, and/or structure your SQL queries, but the final results must be your own, validated work.

<hr>

## Marking criteria

* This assignment is worth 20% of the final grade.
* **IMPORTANT**: according to the School policy, you **must** submit an answer to this assignment; otherwise, you will be graded 0 (zero).
* Refer to [Moodle](https://moodle.lse.ac.uk/course/view.php?id=11282) for the General Assessment Criteria for Undergraduate Degrees document.

| Problem breakdown  | Max marks |
| ------------- | ------------- |
| 1A - Correct database creation (entities, attributes, PK/FK mapped into collections) and data loading | 20 |
| 1B - Correct query and display of results, code documentation/organisation | 10 |
| 1C - Correct query and display of results, code documentation/organisation | 10 |
| 1D - Correct query and display of results, code documentation/organisation | 10 |
| 2A - Correct database creation (entities, attributes, PK/FK mapped into graph), Property Graph model displayed | 10 |
| 2B - Correct data loading, Instance graph displayed | 10 |
| 2C - Correct query and display of results, code documentation/organisation | 10 |
| 2D - Correct query and display of results, code documentation/organisation | 10 |
| 2E - Correct query and display of results, code documentation/organisation | 10 |
| TOTAL | 100 |

<hr>

## Extension requests

You have the right to ask for an extension under some circumstances, as per LSE Extension Policy. Check [here](https://info.lse.ac.uk/current-students/services/assessment-and-results/exceptional-circumstances/extension-policy) for guidance and the necessary documents. **Please note that any extensions must be requested and approved before the deadline, so do not leave this to the last minute as it may incur late penalties being applied to your work**. You should submit your requests to Dr. Christine Yuen (BSc Data Science programme director) and Steve Ellis (Undergraduate Programmes Manager) for analysis. See here for contact details, under Academic Faculty and Professional Service Staff, respectively. If you have adjustments in place and need an extension, follow the same procedure and contact your teachers for advice.

<hr>

## Feedback and provisional marks

Feedback and provisional marks will be provided in a markdown (.md) file in your “assignment1” repository by the expected date. Please, note that we do our best to provide you with relevant and meaningful feedback by the intended deadline, but **we reserve the right to delay any feedback while any extension requests are in place. You may also note that all marks are provisional and subject to changes to comply with School and departmental policies on mark distributions and as a result of external examiners and sub-board revisions**.

<hr>

## Revision of feedback and provisional marks

We advise you to read carefully your feedback file and get in touch with the teaching staff to discuss any points. We are available to revise any specific parts of your feedback when **there is a justifiable reason for that**. Please, **raise any points regarding your feedback and provisional marks up to two weeks after receiving them**. We may refrain from revising any parts of your feedback and provisional marks later in the academic year due to the internal flow/processing of marks across department and school sub-boards and external examiners.
