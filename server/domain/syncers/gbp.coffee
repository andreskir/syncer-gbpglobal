DataSource = require("./dataSource")
GbpProductsApi = require("./gbpGlobal/gbpProductsApi")
GbpOrdersApi = require("./gbpGlobal/gbpOrdersApi")
GbpContactAdapter = require("./gbpGlobal/adapters/gbpContactAdapter")
Promise = require("bluebird")
_ = require("lodash")

module.exports =

class Gbp extends DataSource
  constructor: (user, settings) ->
    super user, settings

    @productsApi = new GbpProductsApi settings
    @ordersApi = new GbpOrdersApi settings
    @adapter = new GbpContactAdapter()

  getAjustes: =>
    @productsApi.getProducts().then (data) =>
      fecha: new Date()
      ajustes: @_parse data

  exportOrder: (salesOrder) =>
    contact = @adapter
      .getCustomer salesOrder.contact, @_findOrCreateVirtualTaxNumber()
    line = _.first salesOrder.lines

    @productsApi.getProducts().then (products) =>
      item = _.find products, (it) => it.sku is line.product.sku
      if not item?
        throw new Error "The product #{JSON.stringify line?.product} wasn't found"

      shipmentId = _.first(salesOrder.shipments)?.integration?.integrationId
      labelUrl =
        if shipmentId?
          "http://mercadolibre.azurewebsites.net/shipments/label?access_token=#{@user.tokens.parsimotion}&ids=#{shipmentId}"
        else ""

      @ordersApi.create
        contact: contact
        itemId: item.id
        quantity: line.quantity
        labelUrl: labelUrl

  _findOrCreateVirtualTaxNumber: (token) =>
    params = @user.deltaParams

    if not params.virtualTaxNumber?
      params.virtualTaxNumber = 99000000

    newTaxNumber = ++params.virtualTaxNumber
    @user.save()
    newTaxNumber
