package com.techgear.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import java.io.IOException;

/** Configured in web.xml. Security filters are TODO pass-through placeholders. */
public class AdminFilter implements Filter {
    public AdminFilter() { }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // TODO: Implement authorization for the ADMIN role.
        chain.doFilter(request, response);
    }
}
