package com.mercury.demo.entities;

import com.fasterxml.jackson.annotation.JsonView;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@NoArgsConstructor
@Getter
@Setter
@EqualsAndHashCode
@ToString
public class Carrier {
    public interface PublicView {}
    public interface InternalView extends PublicView {}

    public enum CommType {
        SMS("sms", "Text Message", 1),
        EMAIL("email", "E-Mail", 2);

        public final String commName;
        public final String displayName;
        public final int priority; // Lower is better

        CommType(String name, String displayName, int priority) {
            this.commName = name;
            this.displayName = displayName;
            this.priority = priority;
        }
    }

    @Id
    @NotNull
    @JsonView(PublicView.class)
    private String id;

    @NotNull
    @JsonView(PublicView.class)
    private String name;

    @NotNull
    @JsonView(InternalView.class)
    private String gateway;

    @NotNull
    @JsonView(InternalView.class)
    private boolean includeCountryCodeInEmail;

    @NotNull
    @JsonView(InternalView.class)
    private CommType type;

    public Carrier(CommType type, String id, String carrierName, String textGateway, boolean includeCountryCodeInEmail) {
        this.id = id;
        this.type = type;
        this.name = carrierName;
        this.gateway = textGateway;
        this.includeCountryCodeInEmail = includeCountryCodeInEmail;
    }

    public String formatTextGateway(final int countryCode, final String phoneNumber) {
        final String prefix;
        if (includeCountryCodeInEmail) {
            prefix = String.format("%s%s", countryCode, phoneNumber);
        } else {
            prefix = phoneNumber;
        }
        return String.format(gateway, prefix);
    }
}
