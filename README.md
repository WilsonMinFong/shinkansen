# Shinkansen

Shinkansen is a Ruby MVC web framework inspired by Ruby on
Rails.  The framework's key components are:

- `Router`: basic routing to Shinkansen controllers
- `ControllerBase`: controller actions, including view rendering
- `ModelBase`: basic Object-Relational Mapping (ORM) functionality

## Router

Add routes for the following CRUD actions: `GET`, `POST`, `PUT`,
and `DELETE`.

```ruby
router.draw do
  get Regexp.new("^/$"), MessagesController, :index
  get Regexp.new("^/messages$"), MessagesController, :index
  post Regexp.new("^/messages$"), MessagesController, :create
  get Regexp.new("^/messages/new$"), MessagesController, :new
  get Regexp.new("^/messages/(?<message_id>\\d+)$"), MessagesController, :show
  delete Regexp.new("^/messages/(?<message_id>\\d+)$"), MessagesController, :destroy
end
```

### API

- `#get`, `#post`, `#put`, `#delete` - Define a route that matches the
  method `GET`, `POST`, `PUT`, or `DELETE`.  Takes
  `(pattern, controller_class, action_name)` as arguments:
  - `pattern` - RegEx pattern to match route
  - `controller_class` - Controller class to instantiate for matched
    route
  - `action_name` - Controller action to execute
- `#draw {|| block}` - Include route definitions in the given block to
  add routes to the router
- `#run(req, res)` - Run the router within a Rack application
  - `req` - Rack `Request` instance
  - `res` - Rack `Response` instance

## Model

Add Shinkansen model functionality by inheriting from the `ModelBase`
class.  Call `finalize!` within the model definition to add getters and
setters corresponding to database column names.

```ruby
class Message < ModelBase
  finalize!
end
```

#### Database Setup

Add the filenames of your SQLite database and setup file to
`db/setup.rb`.  Require `setup.rb` in each of your models.

### API

#### General

- `::finalize!` - Creates getter and setter methods for each database
  column
- `::columns` - Returns an array of symbols representing database column
  names in the database
- `#attributes` - Returns a hash of attributes mapped to attribute
  values
- `#insert` - Adds the class instance to the database
- `#update` - Updates the database row to match attribute values of the
  class instance
- `#save` - Inserts or updates the class instance depending on whether
  or not its `id` is `nil`
- `#destroy` - Deletes the object's database entry

#### Search

  - `::all` - Returns an array of all instances of the class in the
    database
  - `::first`/`::last` - Returns the first/last instance of the class in
    the database
  - `::find(id)` - Searches the database for an entry with the given id
    returning the matching class instance or nil, if it doesn't exist
  - `::where(params)` - Returns an array of class instances that match
    the conditions set in `params`, a hash that maps attributes to match
    values

#### Associations
  - `#belongs_to(name, options)` - Creates a one-to-one association with
    another class.  Takes an association `name` and `options` hash,
    which specifies the following:
    - `:class_name` - Name of the class that the association points to
    - `:foreign_key` - Name of the foreign key within this class
    - `:primary_key` - Name of the primary key within the
      associated class
  - `#has_many(name, options)` - Creates a one-to-many association
    with another model.  Also, takes an association `name` and `options`
    hash, which specifies the following:
    - `:class_name` - Name of the class that the association points to
    - `:foreign_key` - Name of the foreign key within the associated
      class
    - `:primary_key` - Name of the primary key within this class
  - `#has_one_through(name, through_name, source_name)` - Creates a
    one-to-one association by going through a third class.
    - `name` - Name of the association
    - `through_name` - Name of the association defined in this class to
      find the endpoint association
    - `source_name` - Name of the endpoint association

## Controller

Add Shinkansen controller functionality by inheriting from the
`ControllerBase` class.

```ruby
class MessagesController < ControllerBase
  # Controller actions...
end
```

### API

- `#redirect_to(url)` - Builds 302 response that redirects to the given
  `url`
- `#render_content(content, content_type)` - Builds a response with the
  given `content` and `content_type`
- `#render(template_name)` - Builds a `text/html` response with the
  specified ERB `template_name`
- `#session[]`/`#session[]=` - Access/set data within a session cookie
- `#flash[]`/`#flash[]=` - Access/set data within a cookie that's
  cleared with every request
- `#flash.now[]/#flash.now[]=` - Access/set data within a cookies that's
  only available for the current request

## Middleware

Shinkansen contains middleware to render a useful exceptions view upon
internal server error.  To use, add `ShowExceptions` to your Rack app
with `Rack::Builder`.

```ruby
app = Rack::Builder.new do
  use ShowExceptions
  run app
end.to_app
```

## Demo Instructions

  1.  Download or clone this repository.
  2.  `bundle install`
  3.  `cd shinkansen/app`
  4.  `ruby message_board.rb`
  5.  Navigate to `localhost:3000`

## Future Features

- [ ] Static assets middleware
- [ ] CSRF Protection
- [ ] `has_many_through` association
- [ ] DB connection for PostgreSQL
- [ ] Gemify the library
- [ ] Database migrations
