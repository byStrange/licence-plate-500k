const isAdmin = (email: string) => email.includes('@admin')

export default defineNuxtRouteMiddleware(async () => {
  const user = useSupabaseUser()
  
  if (!user.value || !isAdmin(user.value.email!)) {
    return navigateTo('/')
  }
})
