<template>
  <div class="min-h-screen bg-gray-50">
    <nav class="bg-white shadow">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <NuxtLink to="/" class="flex-shrink-0 flex items-center">
              <span class="text-xl font-bold text-gray-900">License Plates</span>
            </NuxtLink>
            <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
              <NuxtLink to="/" class="nav-link">Home</NuxtLink>
              <NuxtLink to="/myorders" class="nav-link">My Orders</NuxtLink>
            </div>
          </div>
          <div class="flex items-center">
            <NuxtLink 
              v-if="user"
              to="/admin/plates" 
              class="nav-link"
            >
              Admin
            </NuxtLink>
            <button 
              v-if="user"
              @click="logout"
              class="ml-4 px-4 py-2 text-sm font-medium text-gray-700 hover:text-gray-900"
            >
              Logout
            </button>
            <NuxtLink 
              v-else
              to="/auth/login"
              class="ml-4 px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-md hover:bg-indigo-700"
            >
              Login
            </NuxtLink>
          </div>
        </div>
      </div>
    </nav>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <NuxtPage />
    </main>
  </div>
</template>

<script setup>
const user = useSupabaseUser()
const client = useSupabaseClient()

const logout = async () => {
  await client.auth.signOut()
  navigateTo('/auth/login')
}
</script>

<style>
.nav-link {
  @apply inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900;
}
</style>