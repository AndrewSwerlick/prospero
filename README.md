# Prospero

A gem for building REST-ish step by step wizards inside of rails

## Installation

Add this line to your application's Gemfile:

    gem 'prospero'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prospero

## Usage

Prospero lets you easily add wizards to your rails controllers to guide users
through your a process.You can define a wizard in a single module and then include
it any of your controllers. Prospero handles creating the controller methods,
defining the logic to move through them, and provides some helpers to quickly create routes

### Defining your wizard

Wizards are defined in a module. To create a new wizard run the provided generator

  rails g prospero:wizard create_event

This will create a new file in `app/wizards` called `create_event.rb`. It will something like this

  module CreateEvent
    include Prospero::Builder

  end

This is your wizard definition. Wizards are made up of steps, so most of your wizard
code will consist of you describe the steps using the step method

  module CreateEvent
    step :create

    step :invite
  end

each call to step will define a new step in the wizard process with the name provided by
the first argument.

In addition to the `create_event.rb` file, the generate will also create a new folder at
`app/wizards/create_event`. This folder will hold your wizard forms. For each step you define
in `create_event.rb` you'll want to create a corresponding form. The form should be a class that
inherits from `Reform::Form`, which is from the excellent [Reform gem](https://github.com/apotonick/reform).
You can also have the generator create these form objects by running

  rails g prospero:wizard create_event create invite

### Forms
The form files are where you define step specific validation and persistence logic. As noted the forms are
built using Reform(https://github.com/apotonick/reform), so you can find detailed documentation there, but we'll
take a brief look here. For the wizard shown above, our first form might look like this

  module CreateEvent
    class Create < Reform::Form
      property :title
      property :start_date

      validates :title, presence: true
      validate :start_date_cannot_be_in_the_past

      def start_date_cannot_be_in_the_past
        errors.add(:start_date, "can't be in the past") if
          !start_date.blank? and expiration_date < Date.today
      end
    end
  end

We define what fields will be on our form using `::property`. Then we use standard active record
validations to setup our validation logic.

### Including in your controller
Once you're done defining your wizard, you can include it in your controller just like a normal module
with

class EventsController < ApplicationController
  include CreateEvent
  # other controller code...
end

This will automatically create a series of methods based on your step names. Each step will get two methods

  `<step_name>_step_show`
  `<step_name>_step_update`

so in our case we'll have four methods total `create_step_show`, `create_step_update`,
`invite_step_show`, `invite_step_update`.

The `<step_name>_step_show` methods will be empty by default, but will allow you to define a view for your step
in `app/view/<controller_name>/<step_name>_step_show`. The `<step_name>_step_update` however
will have all the logic necessary to update your model with the data from the step. It will load up
a model based upon the url id param, create a Reform form, with that model, use validate the params
provided by the user with that form, save the params and direct the user to the next step
if validation passes, or return the user to the previous step with error messages if the validation fails.

### Routes
Once you've included your wizard in your controller, the last step is to register routes for the new methods
your wizard has created, go into `config/routes.rb` and add the following

  `CreateEvent.register_routes_for "events"`

This will create routes for each of your steps. These will be named routes, named using the following convention.

  <action>_<step_name>_step_for_<controller_singular_name>

So for the create_step_update method from our example above, it would be this

  `update_create_step_for_event`



## Contributing

1. Fork it ( https://github.com/[my-github-username]/prospero/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
