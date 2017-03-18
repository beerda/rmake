test_that('is.recipe', {
  expect_true(is.recipe(recipe(target='target')))
  expect_false(is.recipe(list(target='target')))
})
