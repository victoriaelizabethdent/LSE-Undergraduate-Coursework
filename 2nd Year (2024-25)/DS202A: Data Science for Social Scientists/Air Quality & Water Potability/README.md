[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/XamdkzAK)
# ✏️ W08 Summative

*Author: Dr Ghita Berrada*


⏲️ **Due Date**:

- 21 November 2024 at 5pm (London time)

If you update your files on GitHub after this date without an authorised extension, you will receive a [late submission penalty](https://info.lse.ac.uk/current-students/services/assessment-and-results/exams/exam-discipline-and-academic-misconduct).

Did you have an extenuating circumstance and need an extension? Send an e-mail to 📧 [Kevin](mailto:DSI.ug@lse.ac.uk?subject=DS202W%20-%20W07%20Summative%20Extension)

🎯 **Main Objectives:**

- Demonstrate your ability to write a report in Quarto Markdown
- Demonstrate your `dplyr` and `ggplot2` skills
- Demonstrate your ability to fit a linear/logistic regression model
- Demonstrate your ability to interpret and evaluate the performance of a linear/logistic regression model
- Demonstrate your understanding of supervised learning techniques
- Demonstrate your ability to defend your model choices

⚖️ **Assignment Weight**:

This assignment is worth 20% of your final grade in this course.

<button style="background-color:#c63c4a;border:none;color:#fff;">

30%

</button>

## Do you know your CANDIDATE NUMBER? You will need it.

> _"Your candidate number is a unique five digit number that ensures that your work is marked anonymously. It is different to your student number and will change every year. **Candidate numbers can be accessed using LSE for You.**"_ 

Source: [LSE](https://www.lse.ac.uk/accounting/study/New-Arrival/Exams-and-Assessments)



# 📝 Instructions

1. Go to our Slack workspace's `#announcements` channel to find a GitHub Classroom link entitled 📝 **W08 Summative**. Do not share this link with anyone outside this course!

2. Click on the link, sign in to GitHub and then click on the green button `Accept this assignment`.

3. You will be redirected to a new private repository created just for you. The repository will be named `ds202a-2024-w08-summative-yourusername`, where `yourusername` is your GitHub username. The repository will be private and will contain a `README.md` file with a copy of these instructions.

4. Recall what is your LSE CANDIDATE NUMBER. You will need it in the next step. 

5. Create a `<CANDIDATE_NUMBER>.qmd` file with your answers, replacing the text `<CANDIDATE_NUMBER>` with your actual LSE number. 

    For example, if your candidate number is `12345`, then your file should be named `12345.qmd`.

6. Then, replace whatever is between the `---` lines at the top of your newly created `.qmd` file with the following:

    ```yaml
    ---
    title: "DS202A - W08 Summative"
    author: <CANDIDATE_NUMBER>
    output: html
    self-contained: true
    ---
    ```

    Once again, replace the text `<CANDIDATE_NUMBER>` with your actual LSE CANDIDATE NUMBER. For example, if your candidate number is `12345`, then your `.qmd` file should start with:

    ```yaml
    ---
    title: "DS202A - W08 Summative"
    author: 12345
    output: html
    self-contained: true
    ---
    ```

7. Fill out the `.qmd` file with your answers. Use headers and code chunks to keep your work organised. This will make it easier for us to grade your work. Learn more about the basics of **markdown formatting** [here](https://quarto.org/docs/authoring/markdown-basics.html). 

8. Once you are done, click on the `Render` button at the top of the `.qmd` file. This will create an `.html` file with the same name as your `.qmd` file. For example, if your `.qmd` file is named `12345.qmd`, then the `.html` file will be named `12345.html`. 

    Ensure that your `.qmd` code is reproducible, that is, if we were to restart R and RStudio and run your notebook from scratch, from top to the bottom, we would get the same results as you did.

9. Push both files to your GitHub repository. You can push your changes as many times as you want before the deadline. We will only grade the last version of your assignment. Not sure how to use Git on your computer? You can always add the files via the GitHub web interface.

10. Read the section **How to get help and how to collaborate with others** at the end of this document.

## "What do I submit?"

You will submit two files:

- A Quarto markdown file with the following naming convention: `<CANDIDATE_NUMBER>.qmd`, where `<CANDIDATE_NUMBER>` is your candidate number. For example, if your candidate number is `12345`, then your file should be named `12345.qmd`.

- An HTML file render of the Quarto markdown file.

You don't need to click to submit anything. Your assignment will be automatically submitted when you `commit` **AND** `push` your changes to GitHub. You can push your changes as many times as you want before the deadline. We will only grade the last version of your assignment. Not sure how to use Git on your computer? You can always add the files via the GitHub web interface.

# 🗄️ Get the data

## What data will you be using?

You will be using two distinct datasets for this summative.

## Parts I and II

Your dataset for these parts is a dataset on air quality collected and shared publicly by [@aq_bench]. It is a "collection of aggregated air quality data from the years 2010–2014 and metadata at more than 5500 air quality monitoring stations all over the world, provided by the first Tropospheric Ozone Assessment Report (TOAR) [and it] focuses in particular on metrics of tropospheric ozone, which has a detrimental effect on climate, human morbidity and mortality, as well as crop yields".

**📚 Preparation**

1. Download the data by clicking on the button below.

<a href="AQBench_dataset.csv" style="margin-left:2em;" download>
    <button class="button-61">Download AQBench dataset (csv file)</button>
</a>

2. Download the dataset variable dictionary below:

<a href="AQBench_variables.csv" style="margin-left:2em;" download>
    <button class="button-61">Download AQBench dataset variables dictionary (csv file)</button>
</a>

## Part 3 

The dataset for this part is about water quality and more precisely drinking water potability. It is publicly availably on [Kaggle](https://www.kaggle.com/datasets/adityakadiwal/water-potability/).

**📚 Preparation**

1. Download the data by clicking on the button below.

<a href="water_potability.csv" style="margin-left:2em;" download>
    <button class="button-61">Download water potability dataset (csv file)</button>
</a>


# 📋 Your Tasks

**What do we actually want from you?**

## Part 1: Show us your `dplyr` muscles! (10 marks)

You don't need to use a chunk for each question. Feel free to organise your code and markdown for this part.

1.  Load the data into a data frame called `aq_bench`. Freely explore the data on your own.

2. This dataset comes in mostly clean format but will require some work before it can be used.
   
    a. Filter the dataset into a new dataframe called `aq_bench_filtered` to remove the `lat`, `lon` and `dataset` columns

3. What are the 5 countries with the highest number of rows in the dataset? And what are the 5 countries with the lowest number of rows in the dataset?
   
4. What is the median NO2 per type of area?
   
5. Create a plot that shows the relationship between population density and O3 average values. What does this plot tell you?

## Part 2: Create regression models (45 marks)

In this part, we focus on predicting `o3_average_values`. 

As it was in the previous section, you don't need to use a chunk for each question. Feel free to organise your code and markdown for this part.

1. Create a baseline linear regression model:
   
   - Create the training and test sets:
  
      - create a `df_train` to contain 75% of your original data
      - create a `df_test` to contain 25% of your original
   
   - Now, using **only** the `df_train` data as a starting point, create a linear regression model that predicts the **target variable**
   - How well does your model perform? Just as in the [lab on week 3](https://lse-dsi.github.io/DS202/2024/autumn-term/weeks/week03/lab.qmd), use the residuals plot and a metric of your choosing to justify your reasoning. Can you explain the performance change between the training and test set?
  
2. Now is your time to shine! Come up with your own feature selection or feature engineering or model selection strategy^[Feature engineering is creating new variables from existing ones. For example, you could create a new variable that results from a mathematical transformation of an existing variable.Or you could enrich your dataset with some other publicly available data.] and try to get a better model performance than you had before.
Don't forget to validate your results using the appropriate resampling techniques!<br/> Whatever you do, this is what we expect from you:

   - Show us your code and your model.

   - Explain your choices (of feature engineering, model selection or resampling strategy)

   - Evaluate your model's performance. If you created a new model, compare it to the baseline model. If you performed a more robust resampling, compare it to the single train-test split you did in the previous question.

## Part 3: Create classification models (45 marks)

In this part, we'll focus on predicting `Potability`.

1. Create a baseline logistic regression model:
   
   - Split your data in training and test set (75% for training set)
   - Use whatever metric you feel is most apt for this task to evaluate your model's performance. Explain why you chose this metric.
   - Explain what the regression coefficients mean in the context of this problem.
   - Comment on the goodness-of-fit of your model and its predictive power.

2. Now is your time to shine once again ! Come up with your own feature selection, feature engineering and/or model selection strategy and try to get a better model performance than you had before.
Don't forget to validate your results using the appropriate resampling techniques!
<br/> Whatever you do, this is what we expect from you:

   - Show us your code and your model.

   - Explain your choices (of feature engineering, model selection or resampling strategy)

   - Evaluate your model's performance. If you created a new model, compare it to the baseline model. If you performed a more robust resampling, compare it to the single train-test split you did in the previous question.

# ✔️ How we will grade your work

Following all the instructions, you should expect a score of around 70/100. Only if you go above and beyond what is asked of you _in a meaningful way_ will you get a higher score. Simply adding more code^[Hint: don't just write code, especially uncommented chunks of code. It won't get you very far. You need to explain the code results, interpret them and put them in context.] or text will not get you a higher score; you need to add interesting insights or analyses to get a distinction.

⚠️ You will incur a penalty if you only submit a `.qmd` file and not also a properly rendered `.html` file alongside it!

## Part 1: Show us your `dplyr` muscles! (10 marks)

Here is a rough rubric for this part:

- **2 marks:** You wrote some code but filtered the data incorrectly or did not follow the instructions.
- **5 marks:** You cleaned the initial dataframe correctly correctly, but you might have made some mistakes when tallying the number of rows per countries, calculating the median NO2 per type of area or your plot and conclusions for Task 5 are not correct.
- **7 marks:** You did everything correctly as instructed. Your submission just fell short of perfect. Your code or markdown could be more organised, or your answers were not concise enough (unnecessary, overly long text).
- **10 marks:** You did everything correctly, and your submission was perfect. Wow! Your code and markdown were well-organised, and your answers were concise and to the point.

## Part 2: Create regression models (45 marks)

Here is a rough rubric for this part:

- **<11 marks:** A deep fail. There is no code, or the code/markdown is so insubstantial or disorganised to the point that we cannot understand what you did.
- **11-21 marks:** A fail. You wrote some code and text but ignored important aspects of the instructions (like not using logistic regression)
- **22-33 marks:** You made some critical mistakes or did not complete all the tasks. For example: your pre-processing step was incorrect, your model contained some data leakage (e.g using variables that define others to predict them), or perhaps your analysis of your model was way off.
- **34-38:** Good, you just made minor mistakes in your code, or your analysis demonstrated some minor misunderstandings of the concepts.
- **~39 marks:** You did everything correctly as instructed. Your submission just fell short of perfect. Your code or markdown could be more organised, or your answers were not concise enough (unnecessary, overly long text).
- **>39 marks:** Impressive! You impressed us with your level of technical expertise and deep knowledge of the intricacies of the logistic function and other models. We are likely to print a photo of your submission and hang it on the wall of our offices.

## Part 3: Create classification models (45 marks)

Here is a rough rubric for this part:

- **<11 marks:** A deep fail. There is no code, or the code/markdown is so insubstantial or disorganised to the point that we cannot understand what you did.
- **11-21 marks:** A fail. You wrote some code and text but ignored important aspects of the instructions (like not using logistic regression)
- **22-33 marks:** You made some critical mistakes or did not complete all the tasks. For example: your pre-processing step was incorrect, your model contained some data leakage (e.g using variables that define others to predict them), or perhaps your analysis of your model was way off.
- **34-38:** Good, you just made minor mistakes in your code, or your analysis demonstrated some minor misunderstandings of the concepts.
- **~39 marks:** You did everything correctly as instructed. Your submission just fell short of perfect. Your code or markdown could be more organised, or your answers were not concise enough (unnecessary, overly long text).
- **>39 marks:** Impressive! You impressed us with your level of technical expertise and deep knowledge of the intricacies of the logistic function and other models. We are likely to print a photo of your submission and hang it on the wall of our offices.

# How to get help and how to collaborate with others


## 🙋 Getting help

You can post general coding questions on Slack but should not reveal code that is part of your solution. 

For example, you can ask:

- _"Does anyone know how I can create a logistic regression in tidymodels without a recipe?"_
- _"Has anyone figured out how to do time-aware cross-validation, grouped per country??"_
- _"I tried using something like `df %>% mutate(col1=col2 + col3)` but then I got an error "_ ([Reproducible example](https://stackoverflow.com/help/minimal-reproducible-example))
- _"Does anyone know how I can create a new variable that is the sum of two other variables?"_

You are allowed to share 'aesthetic' elements of your code if they are not part of the core of the solution. For example, suppose you find a really cool new way to generate a plot. You can share the code for the plot, using a generic `df` as the data frame, but you should not share the code for the data wrangling that led to the creation of `df`.

If we find that you posted something on Slack that violates this principle without realising it, you won't be penalised for it - don't worry, but we will delete your message and let you know.

## 👯 Collaborating with others

You are allowed to discuss the assignment with others, work alongside each other, and help each other. However, you cannot share or copy code from others — pretty much the same rules as above.

## 🤖 Using AI help?

You can use Generative AI tools such as ChatGPT when doing this research and search online for help. If you use it, however minimal use you made, you are asked to report the AI tool you used and add an extra section to your notebook to explain how much you used it.

Note that while these tools can be helpful, they tend to generate responses that sound convincing but are not necessarily correct. Another problem is that they tend to create formulaic and repetitive responses, thus limiting your chances of getting a high mark. When it comes to coding, these tools tend to generate code that is not very efficient or old and does not follow the principles we teach in this course.

To see examples of how to report the use of AI tools, see 🤖 [Our Generative AI policy](https://lse-dsi.github.io/DS202/2024/autumn-term/generative-ai.qmd).







