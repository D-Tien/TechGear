package com.techgear.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import java.io.IOException;

/** Configured in web.xml. Security filters are TODO pass-through placeholders. */
public class AuthenticationFilter implements Filter {
    public AuthenticationFilter() { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // TODO: Implement authentication using session attribute currentUser.
        chain.doFilter(request, response);
    }
}
