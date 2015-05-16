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

Prospero is a tool for quickly creating multi-step wizards in your rails app. Prospero differs from other wizard gems like wicked in a number of important ways.

1. It creates a fully RESTfull wizard that exposes a unique url for every step
2. It ensures the presentation logic of the wizard is completely removed from your model layer
3. It allows for fine grained persistence control where you can build the record up as each step is performed, or you can only build your record once all the steps are completed.

### Defining your wizard

Wizards are defined in a module. To create a new wizard run the provided generator

    rails g prospero:wizard create_event

This will create a new file in `app/wizards` called `create_event.rb`. It will something like this

    module CreateEvent
      include Prospero::Wizard

      configuration do
        # your code here...
      end
    end

This is your wizard definition. Wizards are made up of steps, so most of your wizard
code will consist of you describe the steps using the step method

    module CreateEvent
      include Prospero::Wizard

      configuration do
        step :create
        step :invite
      end
    end

each call to step will define a new step in the wizard process with the name provided by
the first argument.

### Forms
Form objects are how Prospero handles validation and persistence logic for each step in your wizard. When the user edits or update's step data, Prospero loads up the associated form for that step. Out of the box, Prospero is optimized to use the excellent [Reform gem](https://github.com/apotonick/reform). from [Nick Sutterer](https://github.com/apotonick), but it will work with any object that exposes the following public methods

1. `initialize(model)` - A constructor that takes in a single argument pointing to the model that this form will persist any data to.
2. `model` - A no arg method which returns the passed in model
3. `validate(params)` - A method that takes in a hash of parameters and validates that they represent a valid operation
4. `errors` - A method that returns an ActiveModel::Errors collection of any validation errors
5. `save` - A method that persists the data back to the model

Prospero looks for form classes inside of the module where your wizard is defined. So in the example above, Prospero will look for the class CreateEvent::Create to generate the create form, and the class CreateEvent::Invite to generate the invite form.

If you choose to create forms using the Reform library, follow the [Reform documentation](https://github.com/apotonick/reform) or our [Reform quickstart](https://github.com/AndrewSwerlick/prospero/wiki/Reform-quickstart). If you're using a different library or creating custom form objects, just ensure the methods above are available and behave as expected.

If you use the generator to create your wizard, reform will automatically create a subfolder with the same name where you can store your form classes. You can even have the generator automatically stub out reform forms if you do this.

    rails g prospero:wizard create_event create invite

### Including in your controller
Once you're done defining your wizard, you can include it in your controller just like a normal module
with

    class EventsController < ApplicationController
      include CreateEvent
      # other controller code...
    end

This will automatically create a series of methods based on your step names. Each step will get two methods

    <step_name>_step_show
    <step_name>_step_update

so in our case we'll have four methods total `create_step_show`, `create_step_update`,
`invite_step_show`, `invite_step_update`.

The `<step_name>_step_show` methods will be empty by default, but will allow you to define a view for your step
in `app/views/<controller_name>/<step_name>_step_show`. The `<step_name>_step_update` however
will have all the logic necessary to update your model with the data from the step. It will load up
a model based upon the url id param, create a Reform form, with that model, use validate the params
provided by the user with that form, save the params and direct the user to the next step
if validation passes, or return the user to the previous step with error messages if the validation fails.

### Routes
Once you've included your wizard in your controller, the last step is to register routes for the new methods
your wizard has created, go into `config/routes.rb` and add the following

    CreateEvent.register_routes_for "events"

This will create routes for each of your steps. These will be named routes, named using the following convention.

    url: {controller}/{step_name}/:id  {step_name}_step_for_{controller_singular_name}


The routes will point to the corresponding step on the `EventsController` with a get action for the
show method and a post action for the update method

So for the create_step_update method from our example above, the route name would be

    create_step_for_event

## Persistence

The above setup works great for simple wizard scenarios. However it has alot of limitations

1. It can't remember which step the user is on so if they don't finish the it all at once they may have to start over.
2. It has to save any data back to the model between steps otherwise it get's lost


All of these limitations stem from the fact that in this simple setup we don't save anything about the steps themselves, just the model data. For more complex scenarios we need to save alot more data. Fortunately, you can easily add this capability in using the Prospero::Persistence module.

To use Prospero::Persistence, first we need to create a migration that will add a table where we can save step data. To create the migraiton run this command.

    rails g prospero:migration

This will create a new migration in your `db/migrate/` folder. Then run

   rake db:migrate

To update your database. This will create a table named wizard_steps where we will store information about how user are progressing through a wizard

Once you've run the migration, you can use the Prospero::Persitence module. Here's an example

    module CreateEvent
      include Prospero::Wizard
      include Prospero::Persistence

      configuration do
        step :create
        step :invite
      end
    end

Including this module in your wizard will expose additional methods and default behaviors to support more complex scenarios.

### Saving and loading the step data

When the Prospero::Persistence module is included in your wizard, every time the user updates a step, the params they posted will be saved in the wizard_steps table. Each entry is tied to a specific ActiveRecord model and each completed step for that model will have one entry. If a user or users hit the same step multiple times, the entry will contain only the latest params

You can access this saved data at any time by calling two new methods exposed in your controller, `all_params` and `params_for(step)`.

`all_params` returns a single hash of all params posted to any steps for the given model. If some of the steps share any params, the hash will only include the most recent value.

`params_for(step)` returns the params that were posted to the given step.

In addition to exposing these methods in your controller, Prospero also extends your form object to include them as well. That way you can write validation methods that will look at data from previous steps, even if you haven't yet saved that data to the ActiveRecord model.

### Browsing to the current step

The controller will have another new method called furthest_step, which will return the last step the user has completed. Prospero will also add a new route such that browsing to /{controller}/current/{id} will redirect the user to the next step after the furthest_step

## Contributing

1. Fork it ( https://github.com/[my-github-username]/prospero/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
