define [
  'lib/component/Component'
  'lib/component/form/Button'
  'lib/component/form/Checkbox'
  'lib/component/form/Dropdown'
  'lib/component/form/RadioButton'
  'lib/component/form/SubmitButton'
  'lib/component/form/TextArea'
  'lib/component/form/TextField'
  'lib/component/Form'
  'lib/component/generics/Map'
  'lib/component/ItemView'
  'lib/component/markup/Label'
  'lib/component/panel/BasePanel'
  'lib/component/panel/FeedbackPanel'
  'lib/component/utils/ComponentStore'
  'lib/component/utils/FilteredCollection'
  'lib/component/utils/InstanceCounter'
  'lib/component/validation/ValidationError'
  'lib/component/validation/validator/BaseValidator'
  'lib/component/validation/validator/EmailAddressValidator'
  'lib/component/validation/validator/PatternValidator'
  'lib/component/validation/validator/StringValidator'
], (
  Component
) ->
  'use strict'
  window.Backbone.Marionette.Component = Backbone.Marionette.Component
