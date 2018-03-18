package org.vld.template.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api")
class ApiController {

    @GetMapping("/products")
    fun products(): String {
        return "Products"
    }

    @GetMapping("/customers")
    fun customers(): String {
        return "Customers"
    }
}
