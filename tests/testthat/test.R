loc_invalid = "invalid"
valid = paste('https://topbrunchspots.com', 
              '/wp-content/uploads/2022/05/AF1QipM',
              '-ql78yz46DGynt2tb1l7i8gK8zOAfN8dCQqiP',
              'w1600-h1000-k-no.jpeg', sep='')

test_that("if loading an image from a url or a location works", {
  # throw error when url or location is not valid
  expect_error(image2rgb(loc_invalid))
  
  # built-in data returns a dataframe
  expect_true(class(image2rgb()) == "data.frame")
  
  # output dataframe has three color channels
  expect_equal(dim(image2rgb())[2], 3)  # built-in image file
  expect_equal(dim(image2rgb(valid))[2], 3) # image file from valid url
})



# c1, c2 colors should has delta e distance around 35
c1_1 = c(0.2745098, 0.1960784, 0.1960784)
c3_1 = c(0.1960784, 0.1960784, 0.1960784)
c1 = c(70, 50, 50)
c2 = c(0, 0, 0)
c3 = c(50, 50, 50) 

test_that("How many contrast", {
  # color distance match
  expect_equal(round(contrast(c1,c2)), 25)
  expect_equal(round(contrast(c2, c3)), 21)
  
  # should also works with max color value 1
  expect_equal(round(contrast(c1,c2)), round(contrast(c1_1,c2, maxColorValue = 1)))
  expect_equal(round(contrast(c2,c3)), round(contrast(c2,c3_1, maxColorValue = 1)))
})


test_that("Is contrast sufficient", {
  # c1 and c2 should match 25
  expect_true(is_sufficient(c1,c2, threshold = 25))
  expect_false(is_sufficient(c1, c2, threshold = 35))
})




