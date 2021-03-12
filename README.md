# Analysis of point-count data in the presence of variable survey methodologies and detection error

> This course was originally developed for [BIOS2](https://bios2.usherbrooke.ca/2021/02/21/training-point-count-data-analysis/) held on March 16, 18, 23, 25 - Pacific: 9am-12pm, Mountain: 10am-1pm, Central: 11am-2pm, Eastern: 12-3pm

This course is aimed towards researchers analyzing field observations,
who are often faced by data heterogeneities due to
field sampling protocols changing from one project to another,
or through time over the lifespan of projects, or trying to combine
'legacy' data sets with new data collected by recording units.

Such heterogeneities can bias analyses when data sets are integrated
inadequately, or can lead to information loss when filtered and standardized to
common standards. Accounting for these issues is important for better
inference regarding status and trend of species and communities.

Analysts of such 'messy' data sets need to feel comfortable
with manipulating the data, need a full understanding the mechanics of the
models being used (i.e. critically interpreting the results and acknowledging
assumptions and limitations), and should be able to make informed choices when
faced with methodological challenges.

The course emphasizes critical thinking and active learning
through hands on programming exercises.
We will use publicly available data sets to demonstrate the data manipulation
and analysis. We will use freely available and open-source R packages.

The expected outcome of the course is a solid foundation for further
professional development via increased confidence in applying these methods
for field observations.

## Instructor

[**Dr. Peter Solymos**](https://peter.solymos.org) \
[Boreal Avian Modelling Project](https://borealbirds.ca) and the [Alberta Biodiversity Monitoring Institute](https://abmi.ca) \
[Department of Biological Sciences](https://www.ualberta.ca/biological-sciences/), [University of Alberta](https://ualberta.ca)

## Outline

> Note: this outline is preliminary and subject to change.

Each day will consist of 3 sessions, roughly one hour each, with short break in between.

| Session | Topic | Files |
| --- | --- | :---: |
| **Day 1** |  **Naive techniques** |    |
|  |  1. Introductions |  [Slides](day1-1-intro.pdf)  |
|  |  2. Organizing point count data |  [Notes](day1-2-data-processing.Rmd)  |
|  |  3. Regression techniques  |  [Notes](day1-3-regression.Rmd)  |
| **Day 2** |  **Behavioral complexities**  |    |
|  |  1. Statistical assumptions and nuisance variables  |    |
|  |  2. Removal modeling techniques  |    |
|  |  3. Practice: removal modeling (simulated & real data)  |    |
| **Day 3** |  **The detection process** |    |
|  |  1. Distance sampling |  Slides  |
|  |  2. Calibrating population density  |    |
|  |  3. Practice: distance sampling (simulated & real data)  |    |
| **Day 4** |  **Behavioral complexities**  |    |
|  |  1. Marginal, joint, and conditional models  |    |
|  |  2. QPAD overview  |    |
|  |  3. Practice: putting it all together (simulated & real data)  |    |


## Before the course

Follow the instructions at the [R website](http://cran.r-project.org) to download and install the most up-to-date base R version suitable for your operating system (the latest R version at the time of writing these instructions is 4.0.4).

Then run the following script in R:

```R
source("https://raw.githubusercontent.com/psolymos/qpad-workshop/main/src/install.R")
```

Having RStudio is not absolutely necessary, but it will make life easier. RStudio is also available for different operating systems. Pick the open source desktop edition from [here](http://www.rstudio.com/products/rstudio/download/) (the latest RStudio Desktop version at the time of writing these instructions is 1.4.1106).

Prior exposure to R programming is not necessary, but knowledge of basic R object types and their manipulation (arrays, data frames, indexing) is useful for following hands-on exercises. Software Carpentry's [Data types and structures in R](http://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures/index.html) is a good resource to brush up your R skills.

## During the course

The course will be delivered online using Zoom. The course will be recorded with the intention of editing the material into a series of video tutorials in the future. Camera on is not required, but is encouraged when engaging in live discussions.

We will keep course related conversation and questions in the following collaborative markdown file: [https://hackmd.io/@psolymos/qpad-2021](https://hackmd.io/@psolymos/qpad-2021) Please scroll down to the Parking Lot section to add your ideas and questions.

### Get course materials

I might make last minute changes, so it is recommended to update your files before the sessions.

If you don't want to use git:

1. Visit [https://github.com/psolymos/qpad-workshop/releases](https://github.com/psolymos/qpad-workshop/releases)
2. Download the latest release into a folder
3. Extract the zip/tar.gz archive
4. Open the `workshop.Rproj` file in RStudio (or open any other R GUI/console and `setwd()` to the directory where you downloaded the file)
5. (You can delete the archive)

If you want to use git: fork or clone the repository

```bash
cd into/your/dir
git clone https://github.com/psolymos/qpad-workshop.git
```

## After the course

Expect some follow up :)

## License

The course material is licensed under [Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/) license. Source code is under [MIT](LICENSE) license.
