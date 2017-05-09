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

### Functionality

- `find`, `insert`, `update`, and `destroy` rows in the database.
- Filter database entries by column values using `where`.
- Connect models with `belongs_to`, `has_many`, or `has_many_through`
  associations.

## Controller

Add Shinkansen controller functionality by inheriting from the
`ControllerBase` class.

```ruby
class MessagesController < ControllerBase
  # Controller actions...
end
```

### Functionality

- Redirect to another URL
- Render an ERB view (located in
  `views/controller_name/template_name.html.erb`)
- Add session and flash cookies
- Add middleware to render an exceptions template upon server error

## Demo Instructions

  1.  Download or clone this repository.
  2.  `bundle install`
  3.  `cd shinkansen/app`
  4.  `ruby message_board.rb`
  5.  Navigate to `localhost:3000`

## Future Features

- [ ] Static assets middleware
- [ ] CSRF Protection
- [ ] DB connection for PostgreSQL
- [ ] Gemify the library
- [ ] Database migrations
