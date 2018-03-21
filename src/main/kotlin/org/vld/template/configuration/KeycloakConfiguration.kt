package org.vld.template.configuration

import org.keycloak.adapters.KeycloakConfigResolver
import org.keycloak.adapters.springboot.KeycloakSpringBootConfigResolver
import org.keycloak.adapters.springsecurity.authentication.KeycloakAuthenticationProvider
import org.keycloak.adapters.springsecurity.config.KeycloakWebSecurityConfigurerAdapter
import org.springframework.context.annotation.Bean
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.core.authority.mapping.SimpleAuthorityMapper
import org.springframework.security.web.authentication.session.NullAuthenticatedSessionStrategy
import org.springframework.security.web.authentication.session.SessionAuthenticationStrategy

@EnableWebSecurity
open class KeycloakConfiguration : KeycloakWebSecurityConfigurerAdapter() {

    override fun keycloakAuthenticationProvider(): KeycloakAuthenticationProvider {
        val authenticationProvider = KeycloakAuthenticationProvider()
        authenticationProvider.setGrantedAuthoritiesMapper(SimpleAuthorityMapper()) // no ROLE_ prefix
        return authenticationProvider
    }

    override fun configure(auth: AuthenticationManagerBuilder?) {
        auth?.authenticationProvider(keycloakAuthenticationProvider())
    }

    // configure Keycloak client in application.properties rather than in keycloak.json
    @Bean
    open fun keycloakConfigResolver(): KeycloakConfigResolver = KeycloakSpringBootConfigResolver()

    override fun sessionAuthenticationStrategy(): SessionAuthenticationStrategy =
            NullAuthenticatedSessionStrategy() // no session for stateless API

    override fun configure(http: HttpSecurity?) {
        super.configure(http)
        http
                ?.authorizeRequests()
                ?.antMatchers("/api/products*")?.hasRole("ProductReader")
                ?.antMatchers("/api/customers*")?.hasRole("CustomerReader")
                ?.anyRequest()?.permitAll()
    }
}
