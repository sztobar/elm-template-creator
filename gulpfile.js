var gulp       = require('gulp');
var livereload = require('gulp-livereload');

gulp.task('css', buildCss);
gulp.task('css:watch', watchCss);

gulp.task('default', watchCss);

function watchCss() {
  var chokidar = require('chokidar');

  livereload.listen();

  chokidar.watch('styles/**/*.css')
    .on('all', buildCss);
}

function buildCss() {
  var postcss       = require('gulp-postcss');
  var postcssNested = require('postcss-nested');
  var cssNext       = require('cssnext');
  var postcssImport = require('postcss-import');

  var postcssPlugins = [postcssImport, postcssNested, cssNext()];

  gulp.src('styles/main.css'/*, { cwd: 'styles' }*/)
    .pipe(postcss(postcssPlugins))
    .pipe(gulp.dest('build'))
    .pipe(livereload());
};
