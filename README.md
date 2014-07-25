node-webkit-stylish-seed
========================

NWHS with Stylus instead of Less. Get rid of all the curly braces!
***

Bootstrap a crossplatform Desktop Application using tools you probably never heard of.

If you're familiar with the node.js world, this sketch should get you informed, if not: an [explanation](https://github.com/kaiyote/node-webkit-stylish-seed/wiki/how-it-works) is placed [in the wiki](https://github.com/kaiyote/node-webkit-stylish-seed/wiki).

![How NWHS works](https://raw.github.com/kaiyote/node-webkit-stylish-seed/master/docs/nwss-arch.png)

  - `brunch new https://github.com/kaiyote/node-webkit-stylish-seed MyApp` to get you started.
  - `npm run compiler` assembles your application into `/_public` and watches file changes (no minification).
  - `npm run mock` assembles your application into `/_public` and watches file changes (with minification - mimics production environment).
  - `npm run app` starts your application locally.
  - `npm run deploy` builds your app for windows, osx and linux. the binaries are placed in `/dist` after building.
  - `npm test` to run unit tests. You can put your unit tests in test/unit.
  - `npm run e2e` to run e2e tests. You can put your e2e tests in test/e2e/[your-test-module].
  - `bower install <frontend-module>` for any frontend-related stuff. jQuery, Angular-plugins, and so on.
  - `npm install my-module` **inside of `app/assets`** to install node.js modules..

#Workflow - detailed

###0. Prerequisites

You need the following stuff installed on your machine:

  - [Node.js & NPM](http://nodejs.org/) (see the instructions for your operating system. Ensure that globally installed NPM modules are in your PATH!)
    - Windows Users: Use a Git Bash or the [PowerShell](http://en.wikipedia.org/wiki/Windows_PowerShell) instead of CMD.exe !
    - Linux Users: You may have to do a [symlink](https://github.com/rogerwang/node-webkit/wiki/The-solution-of-lacking-libudev.so.0).
    - Git. (Brunch and Bower depend on Git to work.) Windows users: try [this](http://git-scm.com/), there is a good usable CLI included which should work with the workflow out-of-the-box. The primitive CMD.exe is currently NOT supported.
  - [Brunch](http://brunch.io/) via a global npm installation: `npm install -g brunch`.
  - [Bower](http://bower.io/) via a global npm installation: `npm install -g bower`.
  - [Grunt](http://gruntjs.com/) via a global npm installation: `npm install -g grunt-cli`.

###1. Bootstrap a new Desktop App!

```
brunch new https://github.com/kaiyote/node-webkit-stylish-seed MyApp
```

*This may take a few minutes depending on your hardware and internet connection, since this git repo will be cloned, a bunch of npm modules will be installed, including the somewhat big [node-webkit](https://github.com/rogerwang/node-webkit), and several bower modules afterwards.*

###2. Develop a Mithril App on Steroids!

`cd MyApp`. Place your typical application code under `/app`. So:

- `/app/styles` contains all your stylesheets as Stylus files. You may look into `/app/styles/app.styl` when fine-tuning your included CSS-related components.
- `/app/scripts` is the folder for your coffeescript application logic, especially your Mithril stuff.
- `/app/assets` is the catch-all directory for everything else, like images or fonts. The whole directory, including the folder-hierarchy, is copied **as is** into the final application folder. *If you want to use npm modules inside your application, install them here, and NOT in the toplevel folder!* Also, the `/app/assets/package.json` is used to describe and build your application, NOT the toplevel `/package.json`!

*The App-level structure is basically the same as [angular-brunch-seed](https://github.com/scotch/angular-brunch-seed).*

All this assembling stuff is managed for you automatically when you run the following command:

```npm run compiler```

While this task is running, every change in your `/app` folder triggers an efficient partial rebuild of the relevant files. Any `bower install <frontend-module>` triggers this, too.

To run your app locally, just enter:

```npm run app```

###3. Add more modules and plugins!

Gone are the days of drag'n'droppin' your jQuery plugins from diverse websites into your script folders. Just use [Bower](http://bower.io/) for anything "browser related". Think of it as a NPM for the frontend. Any components installed by bower are saved in `bower_components` and automatically inserted in the compilation process.

###4. Test ALL the things!

Since your desktop application is basically just a Mithril app, you can use whatever testing framework you feel like using.  This seed uses [node-unit](https://github.com/caolan/nodeunit) for unit-testing, and [Nightwatch](http://nightwatchjs.org/) for e2e testing.

###5. Deploy your App!

When you're done building your awesome app, just type

```npm run deploy```

and you'll have your final application folders located in `/dist` for each major operating system. When performing this task the first time, it'll take several minutes to download the necessary node-webkit binaries per target system.

*So far only tested on OSX and Windows 7/8. The application icon and several minor features still require some work, have a look at [grunt-node-webkit-builder](https://github.com/mllrsohn/grunt-node-webkit-builder) if you want to give a helping hand.*

#Licence

**MIT.** You can assign any licence you want to your built apps, however you should pick the GPL if you are awesome *([like lighttable did](https://news.ycombinator.com/item?id=7024626))*.

#Feedback

- Just use the issues section to discuss features or report bugs.
- There is a thread on [HackerNews](https://news.ycombinator.com/item?id=7094465) and one on [Reddit](http://www.reddit.com/r/webdev/comments/1vumf5/workflow_for_frontend_developers_to_create/).
- If you have general questions not related to this project, you may tweet to [@Hisako1337](https://twitter.com/Hisako1337) (that's (the original author)!).
