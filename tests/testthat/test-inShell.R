test_that("inShell", {
  expect_equal(inShell({ print(x) }),
               c("$(R) - <<\'EOFrmake\'",
                 "{",
                 "    print(x)",
                 "}",
                 "EOFrmake"))
  expect_equal(inShell({
                   x <- 1
                   print(x)
               }),
               c("$(R) - <<\'EOFrmake\'",
                 "{",
                 "    x <- 1",
                 "    print(x)",
                 "}",
                 "EOFrmake"))
})
