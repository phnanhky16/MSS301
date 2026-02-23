package com.kidfavor.userservice.event;

import com.kidfavor.userservice.entity.User;
import lombok.Getter;
import org.springframework.context.ApplicationEvent;

/**
 * Spring ApplicationEvent fired inside the register() transaction.
 * Picked up by UserEventPublisher after the transaction commits.
 */
@Getter
public class UserRegisteredDomainEvent extends ApplicationEvent {

    private final User user;

    public UserRegisteredDomainEvent(Object source, User user) {
        super(source);
        this.user = user;
    }
}

