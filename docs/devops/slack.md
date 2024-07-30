### Java

```java

@Service
@RequiredArgsConstructor
public class SlackService {
    private final RestTemplate restTemplate;
    String slackApiEndpoint = "https://slack.com/api/chat.postMessage";
    String botOAuthToken = "xoxb-...";
    String channelId = "C04EH...";

    public void sendSlackNotification(String course,
                                      String email,
                                      String company,
                                      String phone,
                                      String participantsDesired,
                                      String date) {
        String message = String.format(
                "New request received:\nCourse: %s\nEmail: %s\nCompany: %s\nPhone: %s\nParticipants Desired: %s\nDate: %s",
                course, email, company, phone, participantsDesired, date
        );

        String jsonPayload = String.format(
                "{\"channel\":\"" + channelId + "\",\"text\":\"%s\"}",
                message.replace("\"", "\\\"")
        );

        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json");
        headers.set("Authorization", "Bearer " + botOAuthToken);

        HttpEntity<String> entity = new HttpEntity<>(jsonPayload, headers);

        ResponseEntity<String> response = restTemplate.exchange(slackApiEndpoint, HttpMethod.POST, entity, String.class);
        System.out.println("Response Code: " + response.getStatusCodeValue());
    }


}
```

### Curl
```
curl --location 'https://slack.com/api/chat.postMessage' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer xoxb-' \
--data-raw '{
    "channel": "C04E...",
        "text": "New request received:\nCourse: course_name\nEmail: email@example.com\nCompany: company_name\nPhone: phone_number\nParticipants Desired: number_of_participants\nDate: requested_date"
}'
```