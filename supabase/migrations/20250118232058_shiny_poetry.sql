/*
  # Initial Schema Setup for License Plate Sales

  1. New Tables
    - `plates`
      - `id` (uuid, primary key)
      - `number` (text, unique)
      - `price` (decimal)
      - `status` (text)
      - `created_at` (timestamp)
    - `profiles`
      - `id` (uuid, primary key)
      - `name` (text)
      - `address` (text)
      - `created_at` (timestamp)
    - `orders`
      - `id` (uuid, primary key)
      - `plate_id` (uuid, references plates)
      - `user_id` (uuid, references auth.users)
      - `created_at` (timestamp)
      - `status` (text)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Create plates table
CREATE TABLE plates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  number text UNIQUE NOT NULL,
  price decimal NOT NULL,
  status text NOT NULL DEFAULT 'available',
  created_at timestamptz DEFAULT now()
);

-- Create profiles table
CREATE TABLE profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  name text NOT NULL,
  address text,
  created_at timestamptz DEFAULT now()
);

-- Create orders table
CREATE TABLE orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  plate_id uuid REFERENCES plates(id),
  user_id uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  status text NOT NULL DEFAULT 'pending'
);

-- Enable RLS
ALTER TABLE plates ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Plates policies
CREATE POLICY "Anyone can view available plates" ON plates
  FOR SELECT USING (status = 'available');

CREATE POLICY "Admin can manage plates" ON plates
  FOR ALL TO authenticated
  USING (auth.uid() IN (
    SELECT id FROM auth.users WHERE email LIKE '%@admin%'
  ));

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Orders policies
CREATE POLICY "Users can view own orders" ON orders
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own orders" ON orders
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admin can view all orders" ON orders
  FOR SELECT TO authenticated
  USING (auth.uid() IN (
    SELECT id FROM auth.users WHERE email LIKE '%@admin%'
  ));