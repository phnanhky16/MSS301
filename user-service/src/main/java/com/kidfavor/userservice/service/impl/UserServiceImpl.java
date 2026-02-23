package com.kidfavor.userservice.service.impl;

import com.kidfavor.userservice.dto.request.user.UserUpdateRequest;
import com.kidfavor.userservice.dto.response.UserResponse;
import com.kidfavor.userservice.entity.User;
import com.kidfavor.userservice.entity.enums.Role;
import com.kidfavor.userservice.repository.UserRepository;
import com.kidfavor.userservice.service.UserService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserServiceImpl implements UserService {
    UserRepository userRepository;

        @Override
        // pagination results vary by page and size so caching is omitted here
        public org.springframework.data.domain.Page<UserResponse> getAllUsers(org.springframework.data.domain.Pageable pageable) {
                return userRepository.findAll(pageable)
                                .map(UserResponse::from);
        }

        @Override
        public org.springframework.data.domain.Page<UserResponse> getAllUsers(org.springframework.data.domain.Pageable pageable,
                                                                                                                                                   String keyword,
                                                                                                                                                   Boolean status,
                                                                                                                                                   Role role) {
                org.springframework.data.jpa.domain.Specification<User> spec = (root, query, cb) -> {
                        java.util.List<jakarta.persistence.criteria.Predicate> preds = new java.util.ArrayList<>();
                        if (keyword != null && !keyword.isEmpty()) {
                                String pattern = "%" + keyword.toLowerCase() + "%";
                                preds.add(cb.or(
                                                cb.like(cb.lower(root.get("fullName")), pattern),
                                                cb.like(cb.lower(root.get("email")), pattern)
                                ));
                        }
                        if (status != null) {
                                preds.add(cb.equal(root.get("status"), status));
                        }
                        if (role != null) {
                                preds.add(cb.equal(root.get("role"), role));
                        }
                        return preds.isEmpty() ? null : cb.and(preds.toArray(new jakarta.persistence.criteria.Predicate[0]));
                };
                return userRepository.findAll(spec, pageable).map(UserResponse::from);
        }

    @Override
    @Cacheable(value = "user", key = "#id")
    public UserResponse getUserById(int id) {
        User user = userRepository.findById(id).orElseThrow(()->new RuntimeException("user not found with id:"+id));
        return UserResponse.from(user);
    }

    @Override
    @Cacheable(value = "users", key = "'status:' + #status")
    public List<UserResponse> getUsersByStatus(Boolean status) {
        return userRepository.findByStatus(status).stream()
                .map(UserResponse::from)
                .collect(Collectors.toList());
    }

    @Override
    @Cacheable(value = "users", key = "'role:' + #role")
    public List<UserResponse> getUsersByRole(Role role) {
        return userRepository.findByRole(role).stream()
                .map(UserResponse::from)
                .collect(Collectors.toList());
    }

    @Override
    @Caching(
            put = @CachePut(value = "user", key = "#result.id"),
            evict = {
                    @CacheEvict(value = "users", allEntries = true)
            }
    )    @Transactional
    public UserResponse updateUser(int id, UserUpdateRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(()->new RuntimeException("user not found with id:"+id));
        user.setFullName(request.getFullName());
        user.setPhone(request.getPhone());
        return UserResponse.from(userRepository.save(user));
    }

    @Override
    @Transactional
    @Caching(
            put = @CachePut(value = "user", key = "#id"),
            evict = {
                    @CacheEvict(value = "users", allEntries = true),
                    @CacheEvict(value = "user", key = "'email:' + #result.email")
            }
    )
    public void changeUserStatus(int id) {
        User user = userRepository.findById(id)
                .orElseThrow(()->new RuntimeException("user not found with id:"+id));
        user.setStatus(!user.getStatus());
        userRepository.save(user);
    }

    @Override
    @Transactional
    @Caching(
            put = @CachePut(value = "user", key = "#result.id"),
            evict = {
                    @CacheEvict(value = "users", allEntries = true)
            }
    )
    public UserResponse changeUserRole(int id, Role role) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("user not found with id:" + id));
        user.setRole(role);
        return UserResponse.from(userRepository.save(user));
    }

    @Override
    @Transactional
    @Caching(
            evict = {
                    @CacheEvict(value = "users", allEntries = true),
                    @CacheEvict(value = "user", key = "#id")
            }
    )
    public void deleteUser(int id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("user not found with id:" + id));
        userRepository.delete(user);
    }
    
        @Override
        public long countUsers() {
                return userRepository.count();
        }
}
