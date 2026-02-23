package com.kidfavor.orderservice.service;

import com.kidfavor.orderservice.entity.Order;
import com.kidfavor.orderservice.entity.OrderStatus;
import com.kidfavor.orderservice.repository.OrderRepository;
import com.kidfavor.orderservice.dto.response.OrderResponse;
import com.kidfavor.orderservice.service.impl.OrderServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mockito;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class OrderServiceImplTest {
    private OrderRepository repo;
    private OrderServiceImpl service;

    @BeforeEach
    void setup() {
        repo = Mockito.mock(OrderRepository.class);
        // other dependencies are not relevant for this particular test
        var productClient = Mockito.mock(com.kidfavor.orderservice.client.ProductServiceClient.class);
        var userClient = Mockito.mock(com.kidfavor.orderservice.client.UserServiceClient.class);
        var publisher = Mockito.mock(org.springframework.context.ApplicationEventPublisher.class);
        var couponSvc = Mockito.mock(com.kidfavor.orderservice.coupon.CouponService.class);
        service = new OrderServiceImpl(repo, productClient, userClient, publisher, couponSvc);
    }

    @Test
    void searchOrders_withStatus_buildsSpecification() {
        // prepare a simple page that will be returned by the repository
        Page<Order> stubPage = new PageImpl<>(Collections.emptyList());
        when(repo.findAll(any(Specification.class), any(Pageable.class))).thenReturn(stubPage);

        Pageable pageReq = PageRequest.of(0, 5);
        service.searchOrders(pageReq, null, null, null, null, null, OrderStatus.PENDING);

        // capture the specification passed to repository
        ArgumentCaptor<Specification<Order>> captor = ArgumentCaptor.forClass(Specification.class);
        verify(repo).findAll(captor.capture(), eq(pageReq));
        Specification<Order> spec = captor.getValue();
        assertNotNull(spec, "Specification should not be null when status is supplied");

        // exercise the specification with mocked criteria objects to ensure it tries to
        // build a predicate for status
        Root<Order> root = mock(Root.class);
        CriteriaQuery<?> query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Predicate fakePred = mock(Predicate.class);
        when(cb.equal(any(), any())).thenReturn(fakePred);
        when(cb.and(any(Predicate[].class))).thenReturn(fakePred);

        Predicate result = spec.toPredicate(root, query, cb);
        assertNotNull(result, "toPredicate should return a non-null predicate");
        verify(cb).equal(root.get("status"), OrderStatus.PENDING);
    }
}
