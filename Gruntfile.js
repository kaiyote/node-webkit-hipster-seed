module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('_public/package.json'),
    nodewebkit: {
      options: {
        version: "0.8.5",
        build_dir: './dist',
        // specifiy what to build
        mac: false,
        win: true,
        linux32: false,
        linux64: false
      },
      src: './_public/**/*'
    },
  });

  grunt.loadNpmTasks('grunt-node-webkit-builder');

  grunt.registerTask('default', ['nodewebkit']);
};
