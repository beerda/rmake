library(maker)




job <- list(
  rTask('loadABC.Rdata', depends='abc.csv'),
        # loadABC.Rdata: abc.csv loadABC.R
        #     R --no-save --no-restore -e \
        #         "library(maker); source(loadABC.R); dump(loadABC.Rdata)"

  rTask('preprocess.Rdata', depends=c('loadABC.Rdata', 'loadXYZ.Rdata')),
        # preprocess.Rdata: loadABC.Rdata, loadXYZ.Rdata preprocess.R
        #     R --no-save --no-restore -e \
        #         "library(maker); load(loadABC.Rdata); load(loadXYZ.Rdata); source(preprocess.R); dump(preprocess.Rdata)"

  #rnwTask('report.tex', depends='preprocess.Rdata'),
        # report.tex: report.Rnw, preprocess.Rdata
        #     R --no-save --no-restore -e \
        #         "library(knitr); load(preprocess.Rdata); knit('report.Rnw')"
        #

  pdftexTask('report.pdf', depends='subsection.tex'),
        # report.pdf: report.tex, subsection.tex
        #     xetex report.tex


  task('all', depends='report.pdf', build='')
        # all: report.pdf
        #
)


makefile(job)

makefile()

