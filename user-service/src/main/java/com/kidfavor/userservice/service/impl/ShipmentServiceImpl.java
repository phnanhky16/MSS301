package com.kidfavor.userservice.service.impl;

import com.kidfavor.userservice.dto.request.shipment.ShipmentCreateRequest;
import com.kidfavor.userservice.dto.request.shipment.ShipmentUpdateRequest;
import com.kidfavor.userservice.dto.response.ShipmentResponse;
import com.kidfavor.userservice.entity.Shipment;
import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.repository.ShipmentRepository;
import com.kidfavor.userservice.repository.UserRepository;
import com.kidfavor.userservice.service.ShipmentService;
import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@FieldDefaults(makeFinal = true, level = AccessLevel.PRIVATE)
public class ShipmentServiceImpl implements ShipmentService {
    ShipmentRepository shipmentRepository;
    UserRepository userRepository;
    @Override
    @Cacheable(value = "shipments", key = "'all'")
    public List<ShipmentResponse> getAllShipments() {
        return shipmentRepository.findAll().stream()
                .map(ShipmentResponse::from)
                .collect(Collectors.toList());
    }

    @Override
    @Cacheable(value = "shipment", key = "#id")
    public ShipmentResponse getShipmentById(int id) {
        Shipment shipment = shipmentRepository.findById(id)
                .orElseThrow(()->new RuntimeException("shipment not found with id:"+id));
        return ShipmentResponse.from(shipment);
    }

    @Override
    @Cacheable(value = "shipments", key = "'user:' + #userId")
    public List<ShipmentResponse> getShipmentsByUserId(int userId) {
        return shipmentRepository.findByUserId(userId).stream()
                .map(ShipmentResponse::from)
                .collect(Collectors.toList());
    }

    @Override
    @Cacheable(value = "shipments", key = "'status:' + #status")
    public List<ShipmentResponse> getShipmentByStatus(Boolean status) {
        return shipmentRepository.findByStatus(status).stream()
                .map(ShipmentResponse::from)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "shipments", allEntries = true)
    })
    public ShipmentResponse createShipment(ShipmentCreateRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(()->new RuntimeException("user not found with id:"+request.getUserId()));
        Shipment shipment = new Shipment();
        shipment.setStreet(request.getStreet());
        shipment.setWard(request.getWard());
        shipment.setDistrict(request.getDistrict());
        shipment.setCity(request.getCity());
        shipment.setNote(request.getNote());
        shipment.setUser(user);
        shipment.setStatus(true);
        return ShipmentResponse.from(shipmentRepository.save(shipment));
    }

    @Override
    @Transactional
    @Caching(
            put = @CachePut(value = "shipment", key = "#id"),
            evict = {
                    @CacheEvict(value = "shipments", allEntries = true)
            }
    )
    public ShipmentResponse updateShipment(int id, ShipmentUpdateRequest request) {
        Shipment shipment = shipmentRepository.findById(id)
                .orElseThrow(()->new RuntimeException("shipment not found with id:"+id));
        shipment.setStreet(request.getStreet());
        shipment.setWard(request.getWard());
        shipment.setDistrict(request.getDistrict());
        shipment.setCity(request.getCity());
        shipment.setNote(request.getNote());
        return ShipmentResponse.from(shipmentRepository.save(shipment));
    }

    @Override
    @Transactional
    @Caching(
            evict = {
                    @CacheEvict(value = "shipment", key = "#id"),
                    @CacheEvict(value = "shipments", allEntries = true)
            }
    )
    public void changeShipmentStatus(int id) {
        Shipment shipment = shipmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("shipment not found with id:" + id));
        shipmentRepository.delete(shipment);
    }
}
