@Vehicles = new Mongo.Collection('vehicles')

Meteor.methods
  addVehicle: (vehicleAttrs) ->
    check Meteor.userId(), String
    check vehicleAttrs,
      name: String
      organization: String
      loc: Object

    exists = Vehicles.findOne(name: vehicleAttrs.name)
    if exists
      return (
        exists: true
        _id: exists._id
      )

    user = Meteor.user()
    vehicle = _.extend(vehicleAttrs,
      added: new Date()
      updated: null
      user: user._id
    )

    id = Vehicles.insert(vehicle)
    _id: id

  updateVehicleLocation: (location) ->
    check Meteor.userId(), String
    check location,
      lat: Number,
      lng: Number

    vehicle = Vehicles.findOne(user: Meteor.userId()._id)

    if vehicle is null
      return

    seconds = (new Date().getTime() - vehicle.updated) / 1000

    if seconds <= 5
      return

    Vehicles.update vehicle._id,
      $set:
        loc: location
        updated: new Date()

    name: vehicle.name
