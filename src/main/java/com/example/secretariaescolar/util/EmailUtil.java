package com.example.secretariaescolar.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUtil {

    private static final String REMETENTE = "SEU_EMAIL@gmail.com";
    private static final String SENHA_APP = "SUA_SENHA_DE_APP";

    public static void enviarCodigo(String destino, String codigo) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(REMETENTE, SENHA_APP);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(REMETENTE));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destino));
        message.setSubject("Código de recuperação de senha - Devant");
        message.setText("Seu código de recuperação é: " + codigo);

        Transport.send(message);
    }
}