# application.yml
    prometheus:
      exporter:
        enable: ${PROMETHEUS_EXPORTER_ENABLE:true}
    management:
      endpoints:
        metrics:
          enabled: ${prometheus.exporter.enable:true}
        web:
          exposure:
            include: '*'
      metrics:
        export:
          prometheus:
            enabled: ${prometheus.exporter.enable:true}
        tags:
          application: ${spring.application.name}

# pom.xml
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
        <groupId>io.micrometer</groupId>
        <artifactId>micrometer-registry-prometheus</artifactId>
    </dependency>

# JvmMonitorConfig.java
    import io.micrometer.core.instrument.MeterRegistry;
    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.boot.actuate.autoconfigure.metrics.MeterRegistryCustomizer;
    import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
    import org.springframework.context.annotation.Bean;
    import org.springframework.context.annotation.Configuration;

    @Configuration
    @ConditionalOnProperty(name = "prometheus.exporter.enable", havingValue = "true")
    public class JvmMonitorConfig {

        @Value("${spring.application.name}")
        private String applicationName;

        @Bean
        public MeterRegistryCustomizer<MeterRegistry> getConfig() {
            return registry -> registry.config().commonTags("application", applicationName);
        }

    }