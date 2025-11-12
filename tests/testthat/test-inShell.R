test_that("inShell", {
  expect_equal(inShell({ print(x) }),
               c("$(R) -e '{' \\",
                 "-e '    print(x)' \\",
                 "-e '}'"))
  expect_equal(inShell({
                   x <- 1
                   print(x)
               }),
               c("$(R) -e '{' \\",
                 "-e '    x <- 1' \\",
                 "-e '    print(x)' \\",
                 "-e '}'"))
})
