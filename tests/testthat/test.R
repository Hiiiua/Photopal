url_invalid = "df"
valid = 'https://topbrunchspots.com/wp-content/uploads/2022/05/AF1QipM-ql78yz46DGynt2tb1l7i8gK8zOAfN8dCQqiPw1600-h1000-k-no.jpeg'

test_that("load image from url works", {
  # raise error when url is not valid
  expect_error(image2rgb(url_invalid)) 
  
  # built-in data returns a dataframe
  expect_true(class(image2rgb()) == 'data.frame')
  
  # output dataframe has three color channels
  expect_equal(dim(image2rgb())[2], 3)  # built-in image file
  expect_equal(dim(image2rgb(valid))[2], 3) # image file from valid url
})
