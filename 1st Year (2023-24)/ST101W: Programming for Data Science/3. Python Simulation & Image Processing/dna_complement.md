# Q1. DNA Complement via Functional Programming (15 Marks)

---

## Background Information

In this question, you are asked to solve the problem set 2 "dna complement" question again, but this time you are required to solve it using the "functional programming" tools we introduced in this course.

Recall that a DNA molecule consists of two strands coiled around each other, with each strand being held together by bonds between the bases: Adenine (A) pairs with thymine (T), whilst cytosine (C) pairs with guanine (G).

The two strands of DNA are complementary: each base in one strand is bonded to its complement in the other strand. For example, if one strand of DNA is 'AAAGTCTGAC', the complementary strand would be 'TTTCAGACTG'.

---

## Instructions

1. In [src/dna_complement.py](src/dna_complement.py), define a function `dna_complement()` which takes `str` of length >= 0 that is only composed of combinations of 'A', 'C', 'G', 'T' as an argument and return the corresponding DNA complement (type: `str`)

2. Ensure the function `dna_complement()` works as intended by testing the function in [src/test_dna_complement.py](src/test_dna_complement.py)
   - At least 4 cases are expected
   - Please read the `Requirements on testing` section for the requirements of the tests

---

## Requirements for Part 1

Your implementation must fulfil the following requirements:

- Any functions written must be pure functions
- No change in variable value or modification of objects
- Must make use of at least one of the following appropriately:

  - `map()`
  - `filter()`
  - `functools.reduce()`

  and also make use of at least one anonymous lambda function (a function with no name) as an argument for at least one of them

- Only the following can be used:

  - Built-in functions
    - `map()`
    - `filter()`
  - Basics like:
    - assignment and conditional statements
    - comparison (e.g. `==`, `<=`), logical operators (`and`, `or`, `not`), and arthematic operators (e.g. `+`, `-`)
    - built-in types and data structures covered in the course
    - indexing and slicing
    - membership checking with the use of `in` and `not in`
  - Functions available from the modules from the Python standard library:
    - `reduce()` from `functools`

  If you want to use any other functionality, please consult the lecturer to avoid penalty.

- The following cannot be used:
  - Loops, list comprehension or dictionary comprehension
  - String methods like `isalpha()`, `join()`, etc
- You can reuse and/or update the code you have written for problem set 2, or the solution of problem set 2. If you do so, ensure your final submission fulfils the requirements above

---

## Requirements for Testing (i.e. Part 2)

- The test cases need to be selected following the guidance discussed in the course
  - For example, useful partition and boundary cases should be used
  - Please write a short comment to explain how each case is chosen (e.g. boundary case between xx and yy partition, smallest value, etc)
- "Automate" the tests with the use of `assert` statement
  - Assertion error message is required

---

## Note

- You may find the question quite artificial in the sense that there are quite a lot of restrictions, and some of them are not very natural
  - The question is designed to assess students' ability to apply some specific "functional programming" tools we covered in the course, and therefore students are restricted to a limited set of functionalities to use
- You are allowed to make use of the official documents to learn more about how to use
  - `map()`
  - `filter()`
  - `reduce()` from `functools`

---

## Example Usage

```
>>> dna_complement('AAAA')
TTTT
>>> dna_complement('AAAGTCTGAC')
TTTCAGACTG
```
