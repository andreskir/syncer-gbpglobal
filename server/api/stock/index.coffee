"use strict"
express = require("express")
controller = require("./stocks.controller.coffee")
auth = require("../../auth/auth.service")

router = express.Router()

router.get "/", auth.isAuthenticated(), controller.stocks
router.post "/", auth.isAuthenticated(), controller.sync

module.exports = router
