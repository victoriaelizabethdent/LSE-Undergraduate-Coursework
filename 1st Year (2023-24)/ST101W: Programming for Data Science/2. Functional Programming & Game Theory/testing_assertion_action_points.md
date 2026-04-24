## Testing (5 marks)

Requirements for testing

- Select at least one function to test
- At least 5 good test cases are needed (can be across different functions to test)
- The test cases should be selected following the guidance discussed in the course
  - For example, useful partition and boundary cases should be used
  - Please also write a short comment to explain how each case is chosen (e.g. boundary case between xx and yy partition, smallest value, etc)
- "Automate" the tests with the use of an `assert` statement

Please state where you put your testing below. Note that you can create some .py files or .ipynb files to put your test code:

**We have placed our testing at the bottom of Q3. Collage, in [collage.ipynb](/2023w-ps-8-victoriaelizabethdent/src/collage.ipynb).**

---

## Assertion (5 marks)

Requirements for using assertion to check internal logic

- Check the "always" correct conditions, if the code written is correct
  - Not for checking the pre-conditions. If you are not sure what the differences are, please see the discussion in lecture 8
- Ensure meaningful error messages are used with `assert`

Please state where you have put the assertion statement to check internal logic below:

**We have placed an assertion statement under Part 4 of [Q3. Collage](/2023w-ps-8-victoriaelizabethdent/src/collage.ipynb).**

---

## Action Points (5 marks)

Address all the action points from your feedback for problem set 5 that are relevant to the problem set 8. If your group members are from different problem set 5 groups, a union of all relevant action points should be addressed.

Please list all action points from your feedback for problem set 5 below:

Our main action point was in regards to assuming information about the data (**"the code in part 2 assumes that the titles are unique... it is better to check before doing so"**), and about filtering and re-reading data (**"some data should be filtered out...no need to reread the data multiple times"**)

We have addressed the action points from our feedback for problem set 5 through filtering out unnecessary values and columns (see ['lse_students.ipynb'](./src/lse_students.ipynb)). All necessary imports, modules and libraries, are dowloaded into once at the top of each notebook. We have tried to reduce the amount of assumptions made, and for certain sections of code, we have detailed our assumptions and how they affect our answers.
