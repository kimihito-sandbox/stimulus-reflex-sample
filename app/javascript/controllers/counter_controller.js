import ApplicationController from './application_controller'

/* This is the custom StimulusReflex controller for ExampleReflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  increment(event) {
    event.peventDefault()
    this.stimulate('Counter#increment', 1)
  }
}
