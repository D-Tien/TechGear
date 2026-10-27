package com.techgear.util;

import java.nio.charset.StandardCharsets;

public final class ValidationUtil {
    private ValidationUtil() { }
    public static boolean isValidUsername(String username) {
        return username != null && username.matches("[A-Za-z0-9_.-]{4,30}");
    }
    public static boolean isValidEmail(String email) {
        return email != null && email.length() <= 254 && email.matches("[^\\s@]+@[^\\s@]+\\.[^\\s@]+");
    }
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 8 && password.getBytes(StandardCharsets.UTF_8).length <= 72;
    }
    public static boolean isValidPhone(String phone) {
        return phone == null || phone.isEmpty() || phone.matches("[+0-9 ()-]{6,20}");
    }
}
