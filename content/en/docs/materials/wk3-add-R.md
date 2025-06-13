---
title: "Week 3: Adding the R language to Jupyter Desktop"
date: 2025-05-03
slug: "wk3-jupyter-r"
description: "Instructions for R."
keywords: ["R", "setup", "wk3"]
draft: false
tags: ["R", "jupyter", "setup", "wk3"]
---

### **Student Instructions: Adding R to JupyterLab**

You can copy and paste this guide into your course materials.

---

This guide will walk you through adding the R programming language as an option in your JupyterLab Desktop application.

### **Part A: Install the R Language**

First, you need to install R itself. This is a separate application from JupyterLab.

1.  Go to the official R download site for your operating system:
    *   **Windows:** [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)
        *   Click the large **"Download R-X.X.X for Windows"** link at the top of the page.
    *   **macOS:** [https://cran.r-project.org/bin/macosx/](https://cran.r-project.org/bin/macosx/)
        *   Download the `.pkg` file for your Mac's processor (e.g., `R-4.x.x-arm64.pkg` for Apple Silicon M1/M2/M3, or `R-4.x.x-x86_64.pkg` for Intel Macs). If unsure, your Mac will tell you if you download the wrong one.

2.  Run the installer you downloaded. **Accept all the default settings.** Click "Next" or "Continue" through all the steps without changing anything.

3.  **Verify the installation:**
    *   **Windows:** Find and open the "R" program from your Start Menu. A window titled "R Console" should appear.
    *   **macOS:** Find and open "R.app" from your Applications folder. A "R Console" window should appear.

You can close the R Console for now. The important thing is that it opened successfully.

### **Part B: Install the Jupyter Kernel from within R**

Now we will open R and run two commands to build the bridge to Jupyter.

1.  **Open R again** (the "R Console" from the previous step).

2.  **Copy and paste the entire first command** below into the R Console (where the `>` prompt is) and press **Enter**.

    ```R
    install.packages('IRkernel')
    ```
    *   This may take a few minutes. You might be asked to choose a "CRAN mirror." This is just the download server. Pick any location that is geographically close to you.

3.  After the first command is finished and you see the `>` prompt again, **copy and paste the second command** into the R Console and press **Enter**.

    ```R
    IRkernel::installspec(user = TRUE)
    ```
    *   This command is what makes R visible to JupyterLab. It should finish very quickly.

4.  You can now close the R Console.

### **Part C: Use R in JupyterLab Desktop**

The final step is to restart JupyterLab so it can find your new R kernel.

1.  If JupyterLab Desktop is open, **completely close and re-open it.** This is a critical step!

2.  When JupyterLab launches, look at the "Launcher" screen. You should now see an icon for **R** in the "Notebook" section, right next to the Python 3 icon.

3.  Click the **R** icon to create a new R notebook.

**Setup is complete!** You can now run R code in JupyterLab. To test it, type the following into a notebook cell and run it:

```R
print("Hello from R in Jupyter!")
my_variable <- 10 + 5
print(my_variable)
```