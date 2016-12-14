# Sapwood Ruby Bindings

The Sapwood ruby gem contains bindings to Sapwood API endpoints for any Sapwood
installation.

**Note on Sapwood 2.0:**

Sapwood 2.0 has yet to be released. This repo will not be considered stable
until Sapwood 2.0 is released.

**Note on development cycles:**

I am focusing my open source time on the Sapwood product itself. I add support
to this gem only as I require a new feature in my Sapwood-based projects.

Therefore, support of Sapwood's features is unlikely to comprehensive, new
features will likely be slow to be released, testing will be limited, and error
messages may be vague.

I would greatly appreciate if you create pull requests for new bindings or
features in this gem as you need them or would find them useful. Or, if you are
interesting in leading the development and maintenance of this gem, please get
in touch.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sapwood'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sapwood

## Getting Started

Sapwood requires three attributes to be able to connect to a Sapwood instance:

- `domain`
- `property_id`
- `api_key`

You can set all of these while initializing the client:

```ruby
sapwood = Sapwood::Client.new(:domain => 'your.sapwood.domain',
                              :api_key => 'your_property_api_key',
                              :property_id => 'your_property_id')
```

In some cases you may wish to work with multiple properties within the same project. You can set those on the fly and change at any time (or you could create a new client).

```ruby
sapwood = Sapwood::Client.new(:domain => 'your.sapwood.domain')

sapwood.api_key = 'your_property_api_key'
sapwood.property_id = 'your_property_id'
```

## Collection

A collection is returned to you as an array of `Sapwood::Element` objects.
Supposing you have an instance of a Sapwood client as `sapwood`, here's the
simplest example:

```ruby
# set `sapwood` to a new Sapwood::Client ...

sapwood.collection.read
```

## Element

There are two actions with a single element: create and read.

### Create

To create an element, you will want to include your element's attributes as a
hash. And be sure that you have the `secret` and `template` as options, or the
element will not be created. Here's an example:

```ruby
# set `sapwood` to a new Sapwood::Client ...

sapwood.element.create(:template => 'your_template', :secret => 'your_secret',
                       :another_attr => 'another_attr ...')
```

### Read

You can also retrieve (read) a single element. All you need here is the `id` of
that element.

```ruby
# set `sapwood` to a new Sapwood::Client ...

sapwood.element.read('element_id')
```

### Sapwood::Element

The Sapwood::Element object is a ruby object that maps the elements attributes
to methods. Therefore, if the JSON response from the API looks like this:

```json
[
  {
    "id": 1,
    "name": "Hello World",
    "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit "
  }
]
```

You would have methods `id`, `name`, and `description` on that object. For example:

```ruby
elements = sapwood.elements

elements[0].id
# => 1

elements[0].name
# => "Hello World"

elements[0].description
# => "Lorem ipsum dolor sit amet, consectetur adipisicing elit "
```

### Passing Query Options

You can pass options to `elements` as a function, following the API. For example, say you only wanted elements of the "Post" template.

```ruby
elements = sapwood.elements(:template => 'Post')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seancdavis/sapwood-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
