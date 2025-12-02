<?php

declare(strict_types=1);

use App\Models\User;

test('user can be created with factory', function () {
    $user = User::factory()->create([
        'name' => 'Test User',
        'email' => 'test@example.com',
    ]);

    expect($user->name)->toBe('Test User')
        ->and($user->email)->toBe('test@example.com')
        ->and($user->password)->not->toBeNull();
});

test('user has fillable attributes', function () {
    $user = new User();

    expect($user->getFillable())->toContain('name', 'email', 'password');
});

test('user hides sensitive attributes', function () {
    $user = User::factory()->create();
    $array = $user->toArray();

    expect($array)->not->toHaveKey('password')
        ->and($array)->not->toHaveKey('remember_token');
});

test('user casts attributes correctly', function () {
    $user = User::factory()->create([
        'email_verified_at' => now(),
    ]);

    $casts = $user->casts();

    expect($casts)->toHaveKey('email_verified_at', 'datetime')
        ->and($casts)->toHaveKey('password', 'hashed')
        ->and($user->email_verified_at)->toBeInstanceOf(\Illuminate\Support\Carbon::class);
});

test('user password is hashed', function () {
    $plainPassword = 'password123';
    $user = User::factory()->create([
        'password' => $plainPassword,
    ]);

    expect($user->password)->not->toBe($plainPassword)
        ->and(strlen($user->password))->toBeGreaterThan(10);
});
