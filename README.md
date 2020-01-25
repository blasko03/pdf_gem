# PdfGem
This is a gem for converting HTML to PDF, the rendering engine is Chromium Browser

## Prerequisites
This package depends on node.js and puppeteer run this command for installing them:

```bash
$ npm install -g node puppeteer
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'pdf_gem'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install pdf_gem
```

You may need to add 
```ruby
Mime::Type.register "application/pdf", :pdf
```
to `config/initializers/mime_types.rb`


## Usage

### Usage from controller 

```ruby
class TestController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "template", options #look options section
      end
    end
  end
end
```

> **NOTE** If your layout include other refernces like images, css or javascript you must provide the absolute path to the files, you can set config.action_controller.asset_host = "assets.example.com" in that way rails will include the full path for assets, more on https://apidock.com/rails/v6.0.0/ActionView/Helpers/AssetUrlHelper

### Available lib methods


This method generates pdf from url

```ruby
PdfGem.pdf_from_url(options)
```

This method generates pdf from html string
```ruby
PdfGem.pdf_from_string(options)
```


## Options

- `options` <[Object]> Options object which might have the following properties:
  - `url` <[string]> (Used only for PdfGem.pdf_from_url) This is the url to render.
  - `html` <[string]> (Used only for PdfGem.pdf_from_string) This is the html string to render.
  - `disposition` <[string]> (Use only for controller render) Disposition string (inline/attachment).
  - `filename` <[string]> (Use only for controller render) Filename of the file.
  - `destination` <[string]> (Use only for PdfGem.pdf_from_url and PdfGem.pdf_from_string) The file path to save the PDF to. If no destination is provided, will be returned a binary string
  - `scale` <[number]> Scale of the webpage rendering. Defaults to `1`. Scale amount must be between 0.1 and 2.
  - `displayHeaderFooter` <[boolean]> Display header and footer. Defaults to `false`.
  - `headerTemplate` <[string]> HTML template for the print header. Should be valid HTML markup with following classes used to inject printing values into them:
    - `date` formatted print date
    - `title` document title
    - `url` document location
    - `pageNumber` current page number
    - `totalPages` total pages in the document
  - `footerTemplate` <[string]> HTML template for the print footer. Should use the same format as the `headerTemplate`.
  - `printBackground` <[boolean]> Print background graphics. Defaults to `false`.
  - `landscape` <[boolean]> Paper orientation. Defaults to `false`.
  - `pageRanges` <[string]> Paper ranges to print, e.g., '1-5, 8, 11-13'. Defaults to the empty string, which means print all pages.
  - `format` <[string]> Paper format. If set, takes priority over `width` or `height` options. Defaults to 'Letter'.
  - `width` <[string]|[number]> Paper width, accepts values labeled with units.
  - `height` <[string]|[number]> Paper height, accepts values labeled with units.
  - `margin` <[Object]> Paper margins, defaults to none.
    - `top` <[string]|[number]> Top margin, accepts values labeled with units.
    - `right` <[string]|[number]> Right margin, accepts values labeled with units.
    - `bottom` <[string]|[number]> Bottom margin, accepts values labeled with units.
    - `left` <[string]|[number]> Left margin, accepts values labeled with units.
  - `preferCSSPageSize` <[boolean]> Give any CSS `@page` size declared in the page priority over what is declared in `width` and `height` or `format` options. Defaults to `false`, which will scale the content to fit the paper size.

> **NOTE** By default, generates a pdf with modified colors for printing. Use the [`-webkit-print-color-adjust`](https://developer.mozilla.org/en-US/docs/Web/CSS/-webkit-print-color-adjust) property to force rendering of exact colors.



> Example of working footer template:
```html
<div id="footer-template" style="font-size:10px !important; color:#808080; padding-left:10px">
  <span class="date"></span>
  <span class="title"></span>
  <span class="url"></span>
  <span class="pageNumber"></span>
  <span class="totalPages"></span>
</div>
```

The `width`, `height`, and `margin` options accept values labeled with units. Unlabeled values are treated as pixels.

All possible units are:
- `px` - pixel
- `in` - inch
- `cm` - centimeter
- `mm` - millimeter

The `format` options are:
- `Letter`: 8.5in x 11in
- `Legal`: 8.5in x 14in
- `Tabloid`: 11in x 17in
- `Ledger`: 17in x 11in
- `A0`: 33.1in x 46.8in
- `A1`: 23.4in x 33.1in
- `A2`: 16.54in x 23.4in
- `A3`: 11.7in x 16.54in
- `A4`: 8.27in x 11.7in
- `A5`: 5.83in x 8.27in
- `A6`: 4.13in x 5.83in

> **NOTE** `headerTemplate` and `footerTemplate` markup have the following limitations:
> 1. Script tags inside templates are not evaluated.
> 2. Page styles are not visible inside templates.

## Troubleshooting
In development enviroment if the server runs in single thead mode the app will go in deadlock. Youm must run the server in multithread mode.

## Contributing
You are welcome to contribute.

## License
The gem is available as open source under the terms of the [Apach e2.0 License](https://opensource.org/licenses/Apache-2.0).
