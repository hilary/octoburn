# -*- mode: markdown -*-
---
layout      : post
title       : "Repository Naming for Octopress on Github"
date        : 2012-08-30 10:40
comments    : true
description : Detailed walkthrough of repository naming when deploying Octopress on Github
keywords    : octopress, github, walkthrough, naming
tags        : 
- Octopress
- Github
- walkthrough
---

While the [Octopress instructions][1] for deploying an
Octopress blog on Github are generally quite straightforward,
some confusion over the repository name seems fairly common.
I ran into it myself. Hopefully this post can spare some
other folks hours of research and head-scratching.<!--more-->

## repository name

### personal Octopress blogs use eponymous repositories

For a personal Octopress blog, you **must** use
`<username>.github.com` (where `<username>` is your github username)
as the name of the repository you create on Github:

{% img center /images/posts/github_form.png 'Creating a User Octopress Repository on Github' 'A screenshot of the form for creating a repository on Github, showing hilary.github.com entered in the new repository name field.' %}

From the Github Pages Guide to [User, Organization and Project Pages][2] we
learn that you can only use your full username, anything else will not work.

### project Octopress blogs use their own repositories

Do not create a new repository for a project Octopress blog! The blog
lives in a branch of the project repository called `gh-pages` which is
created by the `rake setup_github_pages` command.

## repository url

The next stumbling block came for me when I ran `bin/rake setup_github_pages`.
Having learned from my last mistake, I was determined to take the instructions
more literally. (You can see where this story is going, right? Right?) 

{% img center /images/posts/bin_rake_setup_first.png 'Invoking rake setup_github_pages' 'A screenshot of an emacs shell window. Rake has been invoked on setup_github_pages and has asked: Enter the read%2Fwrite url for your repository. For example, git%40github.com:your_username%2Fyour_username.github.com' %}

Hmmmm.... HMMMMMMMM.... Check the repo on github. The read/write access url
is `git@github.com:hilary/hilary.github.com.git`. Argh! Now what do I do?
Follow the instructions or the example? I chose incorrectly, and followed
the instructions. Don't do that. Follow the example. Leave off the `.git`:

{% img center /images/posts/bin_rake_setup_github.png 'Invoking rake setup_github_pages correctly' 'Another screenshot of the same emacs shell. git%40github.com:hilary%2Fhilary.github.com has been entered in response to the prompt' %}

## anything else?

I also got my git branches rather tangled and had to untangle them. I
broke those notes off into a separate post (underway). In part, it
seems a little less common of an Octopress noob problem. Mostly,
though, I learned a lot from the experience, and am learning more from
doing an in-depth write-up.

Having Octopress setup problems you haven't solved? Leave a comment and I'll
look over your virtual shoulder and see if I can help.

  [1]: http://octopress.org/docs/deploying/github/
  [2]: https://help.github.com/articles/user-organization-and-project-pages
