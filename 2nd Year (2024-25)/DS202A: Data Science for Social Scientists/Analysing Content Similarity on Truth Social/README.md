[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/jLxnnYYb)
# 📝 W11+1 Summative

*Author: Dr Ghita Berrada* 

💡 **NOTE:** This time, you are not _asked_ to write code as part of the assignment. If you choose to do so, please ensure your code confirms, reinforces, or complements your answers. Adding code just for the sake of it will not help you get a higher grade. 


⏲️ **Due Date**: Tuesday, December 17th, 5pm 

If you update your files on GitHub after this date without an authorised extension, you will receive a [late submission penalty](https://info.lse.ac.uk/current-students/services/assessment-and-results/exams/exam-discipline-and-academic-misconduct).

Did you have an extenuating circumstance and need an extension? Send an e-mail to 📧 [Kevin](mailto:DSI.ug@lse.ac.uk?subject=DS202A%20-%20W11p1%20Summative%20Extension)

⚖️ **Assignment Weight**:

This assignment is worth 30% of your final grade in this course.

> 30% <br/>

 <br/><br/><br/>


> [!IMPORTANT] 
> ## Do you know your CANDIDATE NUMBER? You will need it.
> _"Your candidate number is a unique five digit number that ensures that your work is marked anonymously. It is different to your student number and will change every year. **Candidate numbers can be accessed using LSE for You.**"_ 
> Source: [LSE](https://www.lse.ac.uk/accounting/study/New-Arrival/Exams-and-Assessments)


# 📝 Instructions

👉 Read it carefully, as some details might change from one assignment to another.

1. Go to our Slack workspace's `#announcements` channel to find a GitHub Classroom link entitled 📝 **W11 Summative**. Do not share this link with anyone outside this course!

2. Click on the link, sign in to GitHub, and then click on the green `Accept this assignment` button.

3. You will be redirected to a new private repository created just for you. The repository will be named `ds202a-2024-w11p1-summative-yourusername`, where `yourusername` is your GitHub username. The repository will be private and will contain a `README.md` file with a copy of these instructions.

4. Recall what is your LSE CANDIDATE NUMBER. You will need it in the next step.

5. Create a `<CANDIDATE_NUMBER>.qmd` file with your answers, replacing the text `<CANDIDATE_NUMBER>` with your actual LSE number. 

    For example, if your candidate number is `12345`, then your file should be named `12345.qmd`.

6. Then, replace whatever is between the `---` lines at the top of your newly created `.qmd` file with the following:

    ```yaml
    ---
    title: "DS202A - W11+1 Summative"
    author: <CANDIDATE_NUMBER>
    output: html
    self-contained: true
    ---
    ```

    Once again, replace the text `<CANDIDATE_NUMBER>` with your actual LSE CANDIDATE NUMBER. For example, if your candidate number is `12345`, then your `.qmd` file should start with:

    ```yaml
    ---
    title: "DS202A - W11+1 Summative"
    author: 12345
    output: html
    self-contained: true
    ---
    ```

7. Fill out the `.qmd` file with your answers. **This time, you are not _required_ to write code. Still, you should provide a nicely formatted notebook.**

    - Use headers and code chunks to keep your work organised. This will make it easier for us to grade your work. Learn more about the basics of **markdown formatting** [here](https://quarto.org/docs/authoring/markdown-basics.html). 

8. Once done, click on the `Render` button at the top of the `.qmd` file. This will create an `.html` file with the same name as your `.qmd` file. For example, if your `.qmd` file is named `12345.qmd`, then the `.html` file will be named `12345.html`. 

    - **If you added any code,** ensure your `.qmd` code is reproducible. If we were to restart R and RStudio and run your notebook, it should run without errors, and we should get the same results as you did.

    - If you choose to add code, please ensure your code confirms, reinforces, or complements your answers. Adding code just for the sake of it will not help you get a higher grade.

9. Push both files to your GitHub repository. You can push your changes as many times as you want before the deadline. We will only grade the last version of your assignment. Not sure how to use Git on your computer? You can always add the files via the GitHub web interface.

10. Read the section **How to get help and collaborate with others** at the end of this document.

## "What do I submit?"

You will submit two files:

- A Quarto markdown file with the following naming convention: `<CANDIDATE_NUMBER>.qmd`, where `<CANDIDATE_NUMBER>` is your candidate number. For example, if your candidate number is `12345`, then your file should be named `12345.qmd`.

- An HTML file render of the Quarto markdown file.

You don't need to click to submit anything. Your assignment will be automatically submitted when you `commit` **AND** `push` your changes to GitHub. You can push your changes as many times as you want before the deadline. We will only grade the last version of your assignment. Not sure how to use Git on your computer? You can always add the files via the GitHub web interface.

# 🗄️ The Data

For this assignment, we will use publicly available data from Truth Social that you can download by clicking on the button below:<br/>


<a href="https://zenodo.org/records/7531625/files/truth_social.zip?download=1" style="margin-left:2em;" download>
    <button class="button-61">Download truth_social.zip </button>
</a>

<br/><br/>

> Note: We do not recommend storing the data in your GitHub repository, as it may be too large for version control. Consider using a `.gitignore` file to exclude the data from your repository.

*Truth Social* is social media platform that was launched in February of 2022 about a year after the suspension of Donald Trump from Twitter, Facebook, and other social media platforms. It is
largely stylized after Twitter where Tweets are instead called Truths and ReTweets are instead called ReTruths. Due to the political and social circumstances surrounding its creation and
launch, *Truth Social* has positioned itself as a hub for rightwing social media users disgruntled by mainstream platforms’ attempts to root out hateful and harmful communities and content.

To get a deeper understanding of the data, check the [website where the data is downloaded from](https://zenodo.org/records/7531625), the readme file that comes with the data and [this article](https://ojs.aaai.org/index.php/ICWSM/article/view/22211/21990) that describes the dataset.

# 📋 Your Task

**What do we need from you?**

## Context

While we provide data, we will not specify the insights we seek in some questions. Instead, we will task you with proposing your approach to the data. This mirrors real-world scenarios in data science and academic research, where you are often given a dataset and asked to derive insights or address a problem.

💡 **Remember**: if you decide to write R code, please ensure your code confirms, reinforces, or complements your answers and that it aligns with the style of code we practiced throughout the course. Adding code just for the sake of it will not help you get a higher grade.

## Part 1: Similarity (40 marks)

Suppose we want to calculate the similarity between the posts (i.e Truths) we have in our dataset.

How would you approach this task? And what insights do you derive from this calculation?

## Part 2: Unsupervised Learning (60 marks)

Propose **one compelling research question** that a social scientist could investigate with this dataset using the _unsupervised learning methods_ covered in this course. How would you answer the research question with these methods, in particular:

> 1. Which dataset features would you use to answer your question? Why? Is there any feature engineering involved?
> 2. Which unsupervised learning methods would you use to answer your question? Why?
> 3. (If you wrote any code) How would you interpret the results of your methods?
> 4. Do you see a supervised learning approach being feasible for your research question? Why? Why not?

<br/><br/>

> [!NOTE]
> *Constraints under which you need to operate:*
> 1. It's fine to refine the model you propose to answer your research question but one of your models (original model or refinement(s)) needs to include textual features
> 2. The answer to your research question needs to feature at least two unsupervised learning techniques (aside from dimensionality reduction) but you don't need to try every single method and every single possible set of features either (strike a judicious balance here)!
> 3. If you can't run your models on the full dataset, demonstrating them on a slice of the data is fine.


# ✔️ How we will grade your work

A 70% or above score is considered a distinction in the typical LSE expectation. This means that you can expect to score around 70% if you provide adequate answers to all questions, in line with the learning outcomes of the course and the instructions provided.

Only if you go above and beyond what is asked of you _in a meaningful way_ will you get a higher score. Simply adding more code or text will not get you a higher score. You need to add unique insights or analyses to get a distinction - we cannot tell you what these are, but these should be things that make us go, "_wow, that's a great idea! I hadn't thought of that_".

Here is a rough rubric of how we will grade your answers. Note that the rigor of our marking varies with the expected difficulty of the question – this is reflected on the marking rubric.

## Part 1: Similarity (40 marks)

- **>29 marks:** Your response, besides being accurate, well-explained, effectively formatted, and surprisingly concise, surprised us positively. That is because you might have devised a custom similarity measure logically justified for this dataset or because you actually coded it and provided excellent plots and a compelling interpretation of the results. Either the mathematical formulation you provided or the plots you created provided deep insights into the dynamics of the dataset.

- **29 marks:** Your response is well-structured and covers all the questions concisely. We see a well-justified process of calculating the similarity between the posts, or maybe you demonstrated it directly with well-documented code. You chose a similarity measure that is logical, focusing on its application to the dataset rather than its technical details (we already know how the distances work). Your approach to interpreting the results directly addresses the research question, avoiding generic explanations. The markdown formatting is also excellent.

- **23-28:** The response is accurate and relevant. Clearly, you have thought of how the similarity metrics apply to this particular dataset. However, there are minor slips in some areas. For instance, some justifications are vague or unclear, or the formatting could be improved.

- **17-22:** Your response missed some crucial details from the instructions. The answer is somewhat correct but lacks precision. It is not well-explained. The response is somewhat generic and could apply to any dataset. The markdown formatting is somewhat poor.

- **16 marks:** A pass. We recognise a few keywords, and although the response is somewhat correct, it lacks precision. The answer is so generic that it could apply to any dataset. Your response resembles language copy-pasted from the web or an AI chatbot.

- **<16 marks:** No answer was provided, or the response is very inadequate.

## Part 2: Unsupervised Learning (60 marks)

- **>43 marks:** Besides being correct, precise, greatly formatted, and well-explained, you provided code that confirms, reinforces, or complements your answers. The code aligns with the style of code we practiced throughout the course; your plots are beyond the basic ones, and you provided a compelling interpretation of the results. 

- **43 marks:** Your response is well-structured and covers all the questions concisely. We see a clear explanation of how the question you're asking fits an unsupervised learning model rather than a supervised learning one and what you would do differently process-wise from the supervised learning case (maybe you even included snippets of code to showcase the difference). The choice of algorithm is logical, focusing on its application to the dataset rather than its technical details (we already know how the algorithms work). Your approach to interpreting the results directly addresses the research question, avoiding generic explanations. The markdown formatting is also excellent.

- **34-42:** The response is accurate and relevant. Clearly, you know in which cases you should apply unsupervised learning techniques to this dataset and have come up with interesting questions to match. However, there are minor slips in some areas. For instance, you might have missed a minor step your explanations of the process, some justifications are vague or unclear, or the formatting could be improved.

- **25-33:** Your response missed some crucial details from the instructions. The answer is somewhat correct but lacks precision. It is not well-explained. The response is somewhat generic and could apply to any dataset. The markdown formatting is somewhat poor.

- **24 marks:** A pass. The response is somewhat correct but it lacks precision. The answer is so generic that it could apply to any dataset and doesn't offer any real insights. Your response resembles language copy-pasted from the web or an AI chatbot.

- **<24 marks:** No answer was provided, or the response is very inadequate or irrelevant to the question.


# How to get help and collaborate with others


## 🙋 Getting help

You can post general clarifying questions on Slack.

For example, you can ask:

- _"Where do I find material that compares different clustering techniques?"_
- _"I came across the term 'loadings' when reading about PCA in the textbook, but I don't fully understand it. Does anyone have a good alternative resource about it?"_

You won't be penalized for posting something on Slack that violates this principle without realizing it. Don't worry; we will delete your message and let you know.

## 👯 Collaborating with others

You are allowed to discuss the assignment with others, work alongside each other, and help each other. However, you cannot share or copy code from others — pretty much the same rules as above.

## 🤖 Using AI help?

You can use Generative AI tools such as ChatGPT when doing this research and search online for help. If you use it, however minimal use you made, you are asked to report the AI tool you used and add an extra section to your notebook to explain how much you used it.

Note that while these tools can be helpful, they tend to generate responses that sound convincing but are not necessarily correct. Another problem is that they tend to create formulaic and repetitive responses, thus limiting your chances of getting a high mark. When it comes to coding, these tools tend to generate code that is not very efficient or old and does not follow the principles we teach in this course.

To see examples of how to report the use of AI tools, see 🤖 [Our Generative AI policy](https://lse-dsi.github.io/DS202/2024/autumn-term/generative-ai.html).



