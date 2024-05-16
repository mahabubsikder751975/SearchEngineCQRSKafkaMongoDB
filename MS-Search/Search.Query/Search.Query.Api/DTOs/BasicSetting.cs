using Confluent.Kafka.Admin;
using Search.Common.DTOs;
using Search.Query.Domain.DTOs;


namespace Search.Query.Api.DTOs
{
public  class BasicSetting
    {
        public  string PaymentApiUrl { get; set; }
        public  string ContentBaseUrl { get; set; }

        public  string content_url { get; set; }
        public  string news_image_url { get; set; }
        public  string news_content_url { get; set; }
        public  string data_url { get; set; }
        public  string data_url_v4 { get; set; }
        public  string comments_url { get; set; }
        public  string notification_url { get; set; }
        public  string reffer_message { get; set; }

        public  string FcmServerkey { get; set; }
        public  string FcmSenderID { get; set; }
        public  string WeekStart { get; set; }
        public  string WeekEnd { get; set; }

        public  string FromEmail { get; set; }
        public  string FromName { get; set; }
        public  string SMTP_USERNAME { get; set; }
        public  string SMTP_PASSWORD { get; set; }
        public  string SMTP_PORT { get; set; }
        public  string SMTP_HOST { get; set; }
        public  string FB_Key { get; set; }

        public  string paid_podcast_wav { get; set; }
        public  string[] paid_podcast_type { get; set; }
    }
}