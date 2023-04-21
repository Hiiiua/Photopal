library(imager)
loc_invalid = "invalid"
valid = paste('https://topbrunchspots.com',
              '/wp-content/uploads/2022/05/AF1QipM',
              '-ql78yz46DGynt2tb1l7i8gK8zOAfN8dCQqiP',
              'w1600-h1000-k-no.jpeg', sep='')

test_that("image2rgb", {
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

test_that("contrast", {
  # color distance match
  expect_equal(round(contrast(c1,c2, plot = F)), 25)
  expect_equal(round(contrast(c2, c3, plot = F)), 21)

  # should also works with max color value 1
  expect_equal(round(contrast(c1,c2, plot = F)), round(contrast(c1_1,c2, maxColorValue = 1, plot = F)))
  expect_equal(round(contrast(c2,c3, plot = F)), round(contrast(c2,c3_1, maxColorValue = 1, plot = F)))
})


test_that("is_sufficient", {
  # c1 and c2 should match 25
  expect_true(is_sufficient(c1,c2, threshold = 25))
  expect_false(is_sufficient(c1, c2, threshold = 35))
})

test_that("cimg2rgb", {
  expect_true(class(cimg2rgb(imager::load.image(valid))) == "data.frame")
})

df.rgb = image2rgb()
test_that("palette_create", {
  # the output number of colors in palette should matches with num.color specified
  # if not considering threshold
  expect_equal(dim(palette_create(5, df.rgb, 0, plot = F))[1], 5)
  expect_equal(dim(palette_create(11, df.rgb, 0, plot = F))[1], 11)

  # expect a warning for a high threshold
  expect_warning(palette_create(5, df.rgb, threshold = 35, plot = F, proceed = 1))
  # expect a palette with 5 if insist proceeding
  expect_equal(dim(palette_create(5, df.rgb, threshold = 35, plot = F, proceed = 1))[1], 5)
})


test_that("color_blindness_simulation",{
  # a returned cimg has 4 dimensions
  expect_equal(length(dim(color_blindness_simulation(mode = 'blue'))), 4)
  # the last dimension has rgb
  expect_equal(dim(color_blindness_simulation(mode = 'blue'))[4], 3)
  expect_true(class(color_blindness_simulation(mode = 'blue'))[1] == "cimg")
})

test_that("color_blindness_palette", {
  # default has 5 colors
  expect_equal(dim(color_blindness_palette(threshold = 0, plot_palette = F))[1], 5)
  # returned dataframe should have nrow matches with specified num.color
  expect_equal(dim(color_blindness_palette(num.color = 8, threshold = 0, plot_palette = F))[1], 8)
  # return a matrix
  expect_true(class(color_blindness_palette(num.color = 8, threshold = 0, plot_palette = F))[1] == "matrix")
  # this matrix has four columns: R, G, B and hexcode
  expect_true(dim(color_blindness_palette(num.color = 8, threshold = 0, plot_palette = F))[2] == 4)
})
