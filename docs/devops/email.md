#### Sendgrip

**Configure with keycloak**

- Go to Settings and Sender Authentication
  Verify a Single Sender -> create a new sender
- Go to Email API -> integration Guide -> SMTP Relay
- Set hosts to `smtp.sendgrid.net` and port to `465`
- Enable SSL -> Authentication -> Username and Password

#### SMTP (Simple Mail Transfer Protocol)

Is the standard protocol used for sending and receiving email messages between mail servers. In a typical email flow,
SMTP is used to transmit messages from the sender's mail server to the recipient's mail server.

#### SMTP Relay

An SMTP relay is a mail server or “MTA” (Message Transfer Agent) that is directed to hand off your message to another
mail server that can get your message closer to its intended recipient - the finish line, so to speak. SMTP relays are
essential for every email service provider (ESP), internet service provider (ISP), and any company that hosts their own
email because they help email get delivered to the inbox.

#### Test SMTP

https://www.smtper.net/

#### Google SMTP (old way)

- Login to google account
- Enable TFA
- Search for app password and generate app password
- smtp.gmail.com -> 465 <app_password> -> example@gmail.com

#### Google SMTP (new way)

- Login to google cloud
- Search for Gmail API and enable it
- create a new service account

#### Mailtrap

- https://www.baeldung.com/java-email
